extends KinematicBody

const locomotion_state := {
	'idle' : Vector2(0,0),
	'walk' : Vector2(0,1),
	'run' : Vector2(2,0),
	'crouch_idle' : Vector2(-0.5,0),
	'crouch' : Vector2(-1,0),
	'push' : Vector2(0,-1)
}

const jump_type := {
	'idle' : 0,
	'running' : 1
}

export (float) var scale_factor = 5.0

export (float) var max_running_speed = 1.0 * scale_factor
export (float) var max_walking_speed = 0.4 * scale_factor
export (float) var max_crouching_speed = 0.2 * scale_factor
export (float) var max_pushing_speed = 0.1 * scale_factor
export (float) var acceleration = 10.0 * scale_factor
export (float) var angular_acceleration = 10.0
export (float) var friction = 20.0 * scale_factor
export (float) var gravity = 9.8 * scale_factor
export (float) var jump_height = 0.0 * scale_factor
export (float) var transition_speed = 2.0 

onready var animator = $AnimationTree
onready var mesh = $Remy

var velocity = Vector3.ZERO
var last_animation
var transition_state = 0.0
var is_walking = false
var is_running = false
var is_pushing = false
var is_crouching = false
var is_jumping = false

func _ready():
	pass

func _physics_process(delta):		
	var input_direction = _get_input_direction()
	var target = _get_state(input_direction)
	
	if Input.is_action_pressed("up") || Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down"):	
		var direction = velocity.normalized()
		if direction != input_direction:
			mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(input_direction.x, input_direction.z), delta * angular_acceleration)
	
	transition_state +=  delta * transition_speed
	transition_state = clamp(transition_state, 0.0, 1.0)
	
	if last_animation != target:
		transition_state = 0.0
	
	animator["parameters/locomotion/blend_position"] = animator["parameters/locomotion/blend_position"].linear_interpolate(target, transition_state)
	last_animation = target
	
	if input_direction != Vector3.ZERO:
		var max_speed
		if is_running:
			max_speed = max_running_speed
		elif is_pushing:
			max_speed = max_pushing_speed
		elif is_crouching:
			max_speed = max_crouching_speed
		else:
			max_speed = max_walking_speed
		velocity += input_direction * acceleration * delta
		if velocity.length() >= max_speed:
			velocity = (input_direction * max_speed) + Vector3(0.0, velocity.y, 0.0)
	else:
		# Friction seems awkwarda
		##velocity = lerp(velocity, Vector3.ZERO, friction * delta) 
		velocity = Vector3(0.0, velocity.y, 0.0)
		
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
func _get_state(input_direction):		
	if is_jumping:
		return last_animation
	
	is_walking = false
	is_running = false
	is_pushing = false
	is_crouching = false
	
	var target
	if Input.is_action_pressed("up") || Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down"):	
		if Input.is_action_pressed("run"):
			target = locomotion_state.run
			is_running = true
		elif Input.is_action_pressed("crouch"):
			target = locomotion_state.crouch
			is_crouching = true
		elif Input.is_action_pressed("push"):
			target = locomotion_state.push
			is_pushing = true
		else:
			target = locomotion_state.walk
			is_walking = true
	else:
		if Input.is_action_pressed("crouch"):
			target = locomotion_state.crouch_idle
		else:
			target = locomotion_state.idle
			
	if Input.is_action_just_pressed("jump"):
		animator["parameters/jump_transition/current"] = jump_type	.running	 if is_running || is_walking else jump_type.idle
		animator["parameters/jump/active"]  = true
		is_jumping = true
	
	return target

func _get_input_direction() -> Vector3:
	var input_direction = Vector3.ZERO
	input_direction.x = int(Input.is_action_pressed('right')) - int(Input.is_action_pressed('left'))
	input_direction.z = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return -input_direction.normalized()

func on_jump_animation_finished():
	is_jumping = false
