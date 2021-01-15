extends KinematicBody3D
		
@export var active = true
@export_range(0,100,0.1) var max_speed = 10;
@export_range(0,100,0.1) var acceleration = 10;
@export_range(0,100,0.1) var friccion = 5;
@export_range(0,100,0.1) var angular_acceleration = 20;
@export_range(0,100,0.1) var gravity = 9.8;

@onready var body : Node3D = $Body
@onready var interactor : Interactor = $Interactor	

var velocity = Vector3.ZERO

func _ready():
	_set_active(active)

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		_interact()

func _physics_process(delta):	
	var input_direction = _get_input_direction()	
	if Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_backward"):	
		body.rotation.y = lerp_angle(body.rotation.y, atan2(-input_direction.x, -input_direction.z), delta * angular_acceleration)
	
	if input_direction != Vector3.ZERO:
		velocity += input_direction * acceleration * delta
		if velocity.length() >= max_speed:
			velocity = (input_direction * max_speed) + Vector3(0.0, velocity.y, 0.0)
	else:
		velocity = velocity.lerp(Vector3(0.0, velocity.y, 0.0), friccion * delta)

	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _get_input_direction() -> Vector3:
	var input_direction = Vector3.ZERO
	input_direction.x = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))
	input_direction.z = int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
	input_direction = input_direction.normalized()
	return input_direction

func _interact(params : Dictionary = {}) -> void:
	_set_active(false)
	interactor.interaction_finished.connect(_on_interaction_finished)
	interactor.interact(self, params)

func _on_interaction_finished(object):
	object.interaction_finished.disconnect(_on_interaction_finished)
	_set_active(true)
	
func _set_active(value : bool) -> void:
	set_physics_process(value)
	set_process(value)
	set_process_input(value)
	set_process_unhandled_input(value)
