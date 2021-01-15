extends KinematicBody

const FLOOR_NORMAL := Vector3(0, 1, 0)
const FLOOR_MAX_ANGLE: float = deg2rad(46.0)

export (bool) var active : bool = true setget _set_active
export(NodePath) var camera_path : NodePath
export(float) var mouse_sensitivity = 12.0
export(float) var camera_fov = 80.0

export(float) var gravity = 30.0
export(int) var walk_speed = 10
export(int) var sprint_speed = 16
export(int) var acceleration = 8
export(int) var deacceleration = 10
export(float, 0.0, 1.0, 0.05) var air_control = 0.3
export(int) var jump_height = 10

var mouse_axis := Vector2()
var move_axis := Vector2()
var sprint_enabled := true
var sprinting := false

onready var camera: Camera = get_node(camera_path)
onready var head : Spatial = $Head
onready var collider : CollisionShape = $CollisionShape 
onready var interactor : Interactor = $Interactor

var velocity := Vector3.ZERO
var direction := Vector3.ZERO

func _init():
	add_to_group("player")

func _ready() -> void:
	_set_active(active)
	_init_camera()

func _init_camera():
	_set_capture_mouse(true)
	camera.fov = camera_fov

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_9):
		if not Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_set_capture_mouse(true)
		else:
			_set_capture_mouse(false)
	
	if Input.is_action_just_pressed("interact"):
		_interact()
		
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		_set_camera_rotation()

func _process(_delta: float) -> void:
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func _physics_process(delta: float) -> void:
	direction = Vector3.ZERO
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	var _snap: Vector3
	if is_on_floor():
		_snap = Vector3(0, -1, 0)
		if Input.is_action_just_pressed("move_jump"):
			_snap = Vector3(0, 0, 0)
			velocity.y = jump_height
	
	velocity.y -= gravity * delta
	
	var _speed: int
	if (Input.is_action_pressed("move_sprint") and can_sprint() and move_axis.x >= 0.5):
		_speed = sprint_speed
		camera.set_fov(lerp(camera.fov, camera_fov * 1.05, delta * 8))
		sprinting = true
	else:
		_speed = walk_speed
		camera.set_fov(lerp(camera.fov, camera_fov, delta * 8))
		sprinting = false
	
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target: Vector3 = direction * _speed
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not is_on_floor():
		_temp_accel *= air_control
	_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.25
		if abs(velocity.x) < _vel_clamp:
			velocity.x = 0
		if abs(velocity.z) < _vel_clamp:
			velocity.z = 0

	var moving = move_and_slide_with_snap(velocity, _snap, FLOOR_NORMAL, true, 4, FLOOR_MAX_ANGLE)
	if is_on_wall():
		velocity = moving
	else:
		velocity.y = moving.y

func _set_camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
		
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot

func can_sprint() -> bool:
	return (sprint_enabled and is_on_floor())

func _set_active(value : bool) -> void:
	active = value
	set_physics_process(value)
	set_process(value)
	set_process_input(value)
	set_process_unhandled_input(value)

func _set_capture_mouse(enabled : bool) -> void:
	if enabled && not Engine.is_editor_hint():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_CatalogueControl_item_selected(item):
	_interact({"item" : item} )

func _interact(params : Dictionary = {}) -> void:
	_set_active(false)
	interactor.connect("interaction_finished", self, "_on_interaction_finished")
	interactor.interact(self, params)

func _on_interaction_finished(object):
	object.disconnect("interaction_finished", self, "_on_interaction_finished")
	_set_active(true)
