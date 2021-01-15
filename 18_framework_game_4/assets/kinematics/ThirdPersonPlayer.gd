@tool
extends KinematicBody3D

@onready var logger = LoggerManager.get_logger("Player")

enum FeetStates {ASCENDING, TOP, DESCENDING, BOTTOM}

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

const collision_state := {
	'idle' : "standing",
	'walk' : "standing",
	'run' : "standing",
	'crouch_idle' : "crouching",
	'crouch' : "crouching",
	'push' : "pushing",
}

@export var active : bool = true #setget _set_active
@export_node_path var mesh_path : NodePath
@export var use_camera_view : bool = false
@export_node_path var camera_path : NodePath #setget _set_camera_path
@export var max_running_speed = 4
@export var max_walking_speed = 1.5
@export var max_crouching_speed = 1.2
@export var max_pushing_speed = 0.5
@export var acceleration = 20
@export var angular_acceleration = 5.0
@export var friction = 5
@export var gravity = 15
@export var jump_height = 4
@export var transition_speed = 2.0 
@export var inverted : bool = false

@onready var animator : AnimationTree = $AnimationTree
@onready var collision_player : AnimationPlayer = $CollisionStates
@onready var raycast_crouch : RayCast3D = $RayCastCrouch
@onready var armature : Node3D = $Armature
@onready var interactor : Interactor = $Interactor
@onready var mesh : MeshInstance3D = get_node(mesh_path)

@onready var skeleton : Skeleton3D = $Armature/Skeleton3D
@onready var skeleton_torch : SkeletonIK3D = $Armature/Skeleton3D/SkeletonHand
@onready var torch : Node3D = $Armature/Skeleton3D/HandBone/Torch
var torch_interpolation_speed : float = 10

@onready var skeleton_head : SkeletonIK3D = $Armature/Skeleton3D/SkeletonHead
@onready var target_head : Node3D = $Armature/Skeleton3D/HeadBone/Target
@onready var skeleton_torso : SkeletonIK3D = $Armature/Skeleton3D/SkeletonTorso
@onready var target_torso : Node3D = $Armature/Skeleton3D/TorsoBone/Target
var lookat_angle_threshold : float = 0.2
var lookat_offset : Vector3 = Vector3(0,-1.2,0)
var lookat_speed : float = 2
var current_Target : Node3D

@onready var raycast_stairs_min : RayCast3D  = $Armature/RayCastStairsMin
@onready var raycast_stairs_max : RayCast3D  = $Armature/RayCastStairsMax
var step_smooth : float = 0.25
var step_max_height : float = 1

@onready var raycast_wall_right : RayCast3D  = $Armature/RayCastWallRight
@onready var raycast_wall_left : RayCast3D  = $Armature/RayCastWallLeft
@onready var skeleton_right_hand : SkeletonIK3D = $Armature/Skeleton3D/SkeletonRightHand
@onready var target_right_hand : Node3D = $Armature/Skeleton3D/RigthHandPosition
@onready var skeleton_left_hand : SkeletonIK3D = $Armature/Skeleton3D/SkeletonLeftHand
@onready var target_left_hand : Node3D = $Armature/Skeleton3D/LeftHandPosition
var offset_hand_position : float = 0.05
var lean_speed : float = 10

@onready var skeleton_turn : SkeletonIK3D = $Armature/Skeleton3D/SkeletonSpine
@onready var target_turn: Node3D = $Armature/Skeleton3D/SpineBone/Target
var turn_amount : float = 15
var turn_friccion_amount : float = 0.05
var previous_direction : Vector3 = Vector3.ZERO
var turn_interpolation_speed : float = angular_acceleration * 2
var turn_friccion : float = 0

@onready var raycast_right_foot_pos : Node3D = $Armature/Skeleton3D/RightFootBone/RayCastPosition
@onready var skeleton_right_foot : SkeletonIK3D = $Armature/Skeleton3D/SkeletonRightFoot
@onready var target_right_foot : Node3D = $Armature/Skeleton3D/RigthFootPosition
@onready var raycast_left_foot_pos : Node3D = $Armature/Skeleton3D/LeftFootBone/RayCastPosition
@onready var skeleton_left_foot : SkeletonIK3D = $Armature/Skeleton3D/SkeletonLeftFoot
@onready var target_left_foot : Node3D = $Armature/Skeleton3D/LeftFootPosition
@onready var target_hips_bone : Node3D = $Armature/Skeleton3D/HipsBone/Target
var previous_left_foot_pos : Vector3 = Vector3.ZERO
var previous_right_foot_pos : Vector3 = Vector3.ZERO
var previous_left_foot_vel : float = 0
var previous_right_foot_vel : float = 0
var offset_foot_position : Vector3 = Vector3(0, 0.05, 0)
var foot_speed : float = 20 # Must be relative large to quickly change to pose Default 20
var hips_speed : float = 20 # Must be relative large to quickly change to pose  Default 20
var foot_position_threshold: float = 0.2 # Must be relative large to check feets position everytime. Default 0.2
var foot_collision_threshold: float = 0.2 # The collision must be similar to is_in_floor. Default 0.25
var hips_offset_threshold: float = 0.2 # Offset to avoid the update of the hips. Default 0.1
var foot_raycast_length : float = 1
var debug_feet_enabled : bool = false

var camera : Camera3D 
var velocity = Vector3.ZERO
var previous_state = Vector2.ZERO
var transition_state = 0.0
var current_collision_state = collision_state.get("idle")
var is_idle = false
var is_walking = false
var is_running = false
var is_pushing = false
var is_crouching = false
var is_jumping = false
var is_turning : bool = false

func _init():
	add_to_group("player")

func _ready():
	_set_active(active)
	if Engine.is_editor_hint():
		return
	_set_camera_path(camera_path)

func _input(event):
	if Engine.is_editor_hint():
		return
		
	if Input.is_action_just_pressed("interact"):
		_interact()

var refresh : bool = false

func _physics_process(delta):	
	if Engine.is_editor_hint():
		return
		
	var input_direction = _get_input_direction()
	
	if use_camera_view:
		input_direction = _convert_direction_from_camera(input_direction, camera)
	
	var state = _get_state(input_direction)
	
	if not is_jumping && (Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_backward")):	
		var previous_rotation: float = armature.rotation.y
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(input_direction.x, input_direction.z), delta * angular_acceleration)
		var delta_rotation : float = armature.rotation.y - previous_rotation
		if not skeleton_turn.is_running():
			skeleton_turn.start()
		target_turn.rotation.y = delta_rotation * sqrt(turn_amount)
		is_turning = true
		skeleton_turn.interpolation = 0.02

	if is_turning && skeleton_turn.interpolation <= 0.5:
		skeleton_turn.interpolation = lerp(skeleton_turn.interpolation, 0.6, turn_interpolation_speed * delta)
	else:
		is_turning = false
		skeleton_turn.interpolation = lerp(skeleton_turn.interpolation, 0.02, turn_interpolation_speed * delta)

	transition_state +=  delta * transition_speed
	transition_state = clamp(transition_state, 0.0, 1.0)
	
	if previous_state != state:
		transition_state = 0.0
	
	#if state != null:
		# TODO: Godot 4.0 throw nulls using inidexinig and calliing to a function
		#animator["parameters/locomotion/blend_position"] = animator["parameters/locomotion/blend_position"].lerp(state, transition_state)
	animator["parameters/locomotion/blend_position"] = animator.get("parameters/locomotion/blend_position").lerp(state, transition_state)
	
	previous_state = state
	
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
			
		var turn_amount : float = previous_direction.normalized().dot(input_direction.normalized())
		if turn_amount <= 0:
			turn_friccion = 0
			velocity = Vector3(0.0, velocity.y, 0.0)	
			animator["parameters/locomotion_time/scale"] = 0
		elif turn_amount <= 0.9:
			turn_friccion = sqrt(abs(turn_amount * 0.5))
			velocity *= turn_friccion	
			animator["parameters/locomotion_time/scale"] = turn_friccion
			
		turn_friccion = lerp(turn_friccion, 1, turn_friccion_amount)
		velocity += input_direction * acceleration * turn_friccion * delta
		if velocity.length() >= max_speed:
			velocity = (input_direction * max_speed) + Vector3(0.0, velocity.y, 0.0)
		velocity -= _step_on_object()
		# TODO: Godot 4.0 Does not allow to call to a metho using indexes
		animator["parameters/locomotion_time/scale"] = lerp(animator.get("parameters/locomotion_time/scale"), 1, acceleration * turn_friccion * delta)
	else:
		turn_friccion = 0
		velocity = Vector3(0.0, velocity.y, 0.0)
		#velocity = lerp(velocity, Vector3.ZERO, friction * delta) 
		animator["parameters/locomotion_time/scale"] = lerp(animator.get("parameters/locomotion_time/scale"), 0, 1/friction * delta)
		
	if Input.is_key_pressed(KEY_Z):
		if not skeleton_torch.is_running():
			skeleton_torch.start()
		torch.visible = true
		skeleton_torch.interpolation = lerp(skeleton_torch.interpolation, 1, torch_interpolation_speed * delta)
	elif skeleton_torch.is_running():
		if skeleton_torch.interpolation <= 0.05:
			skeleton_torch.stop()
			skeleton.clear_bones_global_pose_override()
		torch.visible = false
		skeleton_torch.interpolation = lerp(skeleton_torch.interpolation, 0.02, torch_interpolation_speed * delta)

	#if not is_jumping:
	#	current_Target = interactor.get_target()
	#	_set_target_lookat(current_Target, target_torso, skeleton_torso, 0.5, delta)
	#	_set_target_lookat(current_Target, target_head, skeleton_head, 1, delta)
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		# TODO: Godot 4 does not allow using indexes iin dictionaries
		animator["parameters/jump_transition/current"] = jump_type.get("running") if is_running else jump_type.get("idle")
		animator["parameters/jump/active"]  = true
		is_jumping = true
		#if not is_running:
		#	yield(get_tree().create_timer(0.7), "timeout")
		velocity.y = jump_height

	#if is_idle:
	#	_step_on_wall(delta)
	#else:
	#	_reset_step_on_wall(delta) 
		
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP, true)

	#if Input.is_action_pressed("up") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_backward"):	
	#if _get_horizontal_velocity().length() > 0:
	#	_reset_feet_position(skeleton_right_foot)
	#	_reset_feet_position(skeleton_left_foot)
	#_foot_on_step_position(delta) 
	
	previous_direction = input_direction
	#skeleton.clear_bones_global_pose_override()

func _get_horizontal_velocity() -> Vector3:
	return Vector3(velocity.x,0, velocity.z)

func _step_on_object() -> Vector3:
	if raycast_stairs_min.is_colliding() && not raycast_stairs_max.is_colliding():
		return Vector3(0,-step_smooth,0)
	return Vector3.ZERO

func _set_target_lookat(target : Node3D, pivot : Node3D, skeleton_ik : SkeletonIK3D, weight : float, delta: float):
	if target != null:		
		var to_target = target.global_transform.origin - armature.global_transform.origin
		var dot = to_target.normalized().dot(armature.global_transform.basis.z.normalized())
		if  dot >= lookat_angle_threshold:
			if not skeleton_ik.is_running():
				skeleton_ik.start()		
			var xform = pivot.global_transform.looking_at(target.global_transform.origin + lookat_offset, Vector3.UP)
			var euler = xform.basis.get_euler()
			euler.x = euler.x + 0.5 * PI
			euler.y = euler.y + PI
			pivot.global_transform.basis = pivot.global_transform.basis.slerp(Basis(euler), lookat_speed * delta)
			skeleton_ik.interpolation = lerp(skeleton_ik.interpolation, weight, lookat_speed * delta)
			return
	if skeleton_ik.is_running()	&& skeleton_ik.interpolation <= 0.1:
		skeleton_ik.stop()
		skeleton.clear_bones_global_pose_override()
	skeleton_ik.interpolation = lerp(skeleton_ik.interpolation, 0.02, lookat_speed * delta)

func _reset_step_on_wall(delta) -> void:		
	if skeleton_right_hand.is_running() && skeleton_right_hand.interpolation <= 0.1:
		skeleton_right_hand.stop()
		skeleton.clear_bones_global_pose_override()
	if skeleton_left_hand.is_running() && skeleton_left_hand.interpolation <= 0.1:
		skeleton_left_hand.stop()
		skeleton.clear_bones_global_pose_override()
	
	skeleton_right_hand.interpolation = lerp(skeleton_right_hand.interpolation, 0.02, lean_speed * delta)
	skeleton_left_hand.interpolation = lerp(skeleton_left_hand.interpolation, 0.02, lean_speed * delta)

func _step_on_wall(delta):
	var raycast_right_length : float
	var raycast_lefth_length : float
	if raycast_wall_right.is_colliding():
		raycast_right_length = (raycast_wall_right.global_transform.origin - raycast_wall_right.get_collision_point()).length()
	if raycast_wall_left.is_colliding():
		raycast_lefth_length = (raycast_wall_left.global_transform.origin - raycast_wall_left.get_collision_point()).length()
	var raycast : RayCast3D = raycast_wall_right
	var ray_length : float = raycast_right_length
	var skeleton_hand : SkeletonIK3D = skeleton_right_hand
	var other_hand : SkeletonIK3D = skeleton_left_hand
	var target_hand : Node3D = target_right_hand
	var offset_position = -offset_hand_position
	if raycast_right_length > raycast_lefth_length:
		raycast = raycast_wall_left
		ray_length = raycast_lefth_length
		skeleton_hand = skeleton_left_hand
		target_hand = target_left_hand
		other_hand = skeleton_right_hand
		offset_position = -offset_position
		
	var from : Vector3 = raycast.global_transform.origin
	var to : Vector3 = from - (raycast.get_collision_normal().normalized() * ray_length)
	
	var space_state = get_viewport().world_3d.get_direct_space_state() 
	var ray = space_state.intersect_ray(from, to, [self], 2147483647, true, false)
	if ray.empty():
		_reset_step_on_wall(delta)
		return
		
	# Start Debug
#	if mesh_test  == null:
#		_create_mesh()
#	mesh_test.global_transform.origin = ray.position
	# End debug
	
	var cross = raycast.get_collision_normal().normalized().cross(Vector3.UP)
	target_hand.global_transform.origin = ray.position + (cross * offset_position)
	if not skeleton_hand.is_running():
		skeleton_hand.start()
	other_hand.interpolation = lerp(other_hand.interpolation, 0.02, lean_speed * delta)
	skeleton_hand.interpolation = lerp(skeleton_hand.interpolation, 1, lean_speed * delta)

func _foot_on_step_position(delta) -> void:		
	var current_right_foot_pos : Vector3 = raycast_right_foot_pos.global_transform.origin
	var current_left_foot_pos : Vector3 = raycast_left_foot_pos.global_transform.origin

	var current_right_foot_vel : float = _compute_foot_vertical_velocity(current_right_foot_pos, previous_right_foot_pos)
	var current_left_foot_vel : float = _compute_foot_vertical_velocity(current_left_foot_pos, previous_left_foot_pos)
	
	var current_right_foot_state : int = _compute_foot_state(current_right_foot_vel,previous_right_foot_vel)
	var current_left_foot_state : int = _compute_foot_state(current_left_foot_vel,previous_left_foot_vel)
	
	var right_foot_target = _check_foot_target(current_right_foot_pos)
	var left_foot_target = _check_foot_target(current_left_foot_pos)
	
	var is_right_foot_colliding = _check_foot_collision(current_right_foot_pos, right_foot_target.position)
	var is_left_foot_colliding = _check_foot_collision(current_left_foot_pos, left_foot_target.position)
	
	var is_feet_in_step : bool = _check_feet_in_step(right_foot_target.position, left_foot_target.position)
#
	#if is_feet_in_step:
	#	print("I am in a step. May I block the foot on top")

	var move_right_foot_enabled = _check_foot_enabled(skeleton_right_foot, current_right_foot_state, is_right_foot_colliding, is_feet_in_step)
	var move_left_foot_enabled = _check_foot_enabled(skeleton_left_foot, current_left_foot_state,is_left_foot_colliding, is_feet_in_step)
		
	var target_right_debug_color : Color = Color.white
	var target_left_debug_color : Color = Color.white
	
	if _move_foot(skeleton_right_foot, target_right_foot, right_foot_target.position, right_foot_target.normal, move_right_foot_enabled, delta):
		current_right_foot_pos = right_foot_target.position
		target_right_debug_color = Color.green
	
	if _move_foot(skeleton_left_foot, target_left_foot, left_foot_target.position, left_foot_target.normal, move_left_foot_enabled, delta):
		current_left_foot_pos = left_foot_target.position
		target_left_debug_color = Color.green
		
	_move_hips(current_right_foot_pos, current_left_foot_pos, delta)	
		
	if debug_feet_enabled:
		_debug(right_foot_target.position, "target_right_foot",target_right_debug_color)
		_debug(left_foot_target.position, "target_left_foot",target_left_debug_color)
	
	previous_right_foot_pos = current_right_foot_pos
	previous_left_foot_pos = current_left_foot_pos
	
	previous_right_foot_vel = current_right_foot_vel
	previous_left_foot_vel = current_left_foot_vel

func _check_foot_enabled(skeleton_ik : SkeletonIK3D, foot_state : int, is_foot_colliding: bool, is_feet_in_step: bool):
	# TODO: Goot 4 need casting the enums to integer to be compared
	if (is_feet_in_step && is_foot_colliding) || foot_state == int(FeetStates.BOTTOM):
		if foot_state != int(FeetStates.BOTTOM) && foot_state != int(FeetStates.TOP): 
			_reset_feet_position(skeleton_ik)
		return true
	return false

func _check_foot_target(foot_pos : Vector3) -> Dictionary:
	var from = foot_pos + (Vector3.UP * foot_raycast_length)
	var to = foot_pos + (Vector3.DOWN * foot_raycast_length)
	var space_state = get_viewport().world_3d.get_direct_space_state() 
	var ray = space_state.intersect_ray(from, to, [self], 2147483647, true, false)
	if not ray.empty():
		return { "position" : ray.position + offset_foot_position, "normal" : ray.normal}
	return { "position" : Vector3.ZERO, "normal" : Vector3.ZERO }
	
func _check_foot_collision(current_feet_pos : Vector3, target_feet_pos: Vector3) -> bool:
	return true if target_feet_pos != Vector3.ZERO && abs(current_feet_pos.y - target_feet_pos.y) < foot_collision_threshold else false
	
func _check_feet_in_step(target_right_foot_pos : Vector3, target_left_foot_pos: Vector3) -> bool:
	return true if abs(target_right_foot_pos.y - target_left_foot_pos.y) >= foot_position_threshold else false

func _compute_foot_vertical_velocity(current_feet_pos : Vector3, previous_feet_pos: Vector3) -> float:
	var foot_vel : float =  current_feet_pos.y - previous_feet_pos.y
	return 0 if abs(foot_vel) < foot_position_threshold else foot_vel
	
func _compute_foot_state(current_feet_vel : float, previous_feet_vel: float) -> int:
	if current_feet_vel > 0:
		return FeetStates.ASCENDING
	elif current_feet_vel < 0:
		return FeetStates.DESCENDING
	elif current_feet_vel == 0 && previous_feet_vel < 0:
		return FeetStates.BOTTOM
	elif current_feet_vel == 0 && previous_feet_vel > 0:
		return FeetStates.TOP
	
	return FeetStates.BOTTOM
	
func _look_at_target(from : Vector3, to : Vector3, up : Vector3) -> Basis:
	var forward = (to - from).normalized()
	var right = up.normalized().cross(forward).normalized()
	forward = right.cross(up).normalized()
	return Basis(right, up, forward)
	
func _move_foot(skeleton_ik : SkeletonIK3D, target : Node3D, target_position : Vector3, target_normal : Vector3, enabled : bool, delta : float) -> bool:
	if not skeleton_ik.is_running():
		target.global_transform.origin = target_position	
		if target_normal != Vector3.UP && target_normal != Vector3.ZERO:
			target.global_transform.basis = _look_at_target(Vector3.ZERO, armature.global_transform.basis.z, target_normal)
		skeleton_ik.start()
		return true
			
	if enabled:	
		skeleton_ik.interpolation = lerp(skeleton_ik.interpolation, 1, foot_speed * delta)
	else:
		if skeleton_ik.interpolation <= 0.1:
			skeleton_ik.stop()
		skeleton_ik.interpolation = lerp(skeleton_ik.interpolation, 0.02, foot_speed * delta)
	return false

func _move_hips(right_foot_pos : Vector3, left_foot_pos : Vector3, delta : float) -> void:
	if right_foot_pos == Vector3.ZERO || left_foot_pos == Vector3.ZERO:
		return
	
	var right_foot_offset : Vector3 = right_foot_pos - global_transform.origin
	var left_foot_offset : Vector3 = left_foot_pos - global_transform.origin
	var vertical_offset : float = right_foot_offset.y if right_foot_offset.y < left_foot_offset.y else left_foot_offset.y

	if abs(vertical_offset) < hips_offset_threshold:
		return

	var hips_position : Vector3 = (right_foot_pos + left_foot_pos) * 0.5
	hips_position.y = target_hips_bone.global_transform.origin.y + vertical_offset
	
	if debug_feet_enabled:
		_debug(hips_position, "hips_position",Color.aqua)
		
	var bone: int = skeleton.find_bone("hips")
	var rest = skeleton.get_bone_custom_pose(bone)	

	# TODO: Godot 4 does not hace xform_inv method in transform
	#var local_hips_position = target_hips_bone.global_transform.xform_inv(hips_position)
	#rest.origin = lerp(rest.origin, local_hips_position, foot_speed * delta)

	skeleton.set_bone_custom_pose(bone, rest)

func _reset_feet_position(skeleton_ik : SkeletonIK3D):
	if skeleton_ik.is_running():
		skeleton_ik.interpolation = 0.02
		skeleton_ik.stop()

	var bone: int = skeleton.find_bone("hips")
	skeleton.set_bone_custom_pose(bone, Transform.IDENTITY)

func _get_state(input_direction):		
	if is_jumping && not is_on_floor():
		return previous_state
	
	if is_crouching && raycast_crouch.is_colliding():
		var state
		if Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_backward"):	
			state = locomotion_state.get("crouch")
			_set_collsion_state(collision_state.get("crouch"))
			is_crouching = true
		else:
			state = locomotion_state.get("crouch_idle")
			_set_collsion_state(collision_state.get("crouch_idle"))
		return state
	
	is_idle = false
	is_walking = false
	is_running = false
	is_pushing = false
	is_crouching = false
	is_jumping = false
	
	var state
	if Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_backward"):	
		if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_right") || Input.is_action_pressed("move_forward") && Input.is_action_pressed("move_backward"):
			state = locomotion_state.get("idle")
			_set_collsion_state(collision_state.get("idle"))
			is_idle = true
		elif Input.is_action_pressed("move_sprint"):
			state = locomotion_state.get("run")
			_set_collsion_state(collision_state.get("run"))
			is_running = true
		elif Input.is_action_pressed("crouch"):
			state = locomotion_state.get("crouch")
			_set_collsion_state(collision_state.get("crouch"))
			is_crouching = true
		elif Input.is_action_pressed("push"):
			state = locomotion_state.get("push")
			_set_collsion_state(collision_state.get("push"))
			is_pushing = true
		else:
			state = locomotion_state.get("walk")
			_set_collsion_state(collision_state.get("walk"))
			is_walking = true
	else:
		if Input.is_action_pressed("crouch"):
			state = locomotion_state.get("crouch_idle")
			_set_collsion_state(collision_state.get("crouch_idle"))
			is_crouching = true
		else:
			state = locomotion_state.get("idle")
			_set_collsion_state(collision_state.get("idle"))
			is_idle = true
	
	return state

func _get_input_direction() -> Vector3:
	var input_direction = Vector3.ZERO
	input_direction.x = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))
	input_direction.z = int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
	input_direction = input_direction.normalized()
	return -input_direction if not inverted else input_direction

func _convert_direction_from_camera(current_direction: Vector3, camera : Camera3D ) -> Vector3:
	if camera == null:
		return current_direction
		
	var direction = Vector3.ZERO
	var aim = camera.get_global_transform().basis
	direction += aim.z * current_direction.z
	direction += aim.x * current_direction.x
	direction.y = 0
	return direction.normalized()

func _set_active(value : bool) -> void:
	active = value
	if Engine.is_editor_hint():
		value = false 
	set_physics_process(value)
	set_process(value)
	set_process_input(value)
	set_process_unhandled_input(value)

func _set_camera_path(value: NodePath) -> void:
	camera_path = value
	var temp = get_node_or_null(camera_path)
	if temp != null && "camera" in temp:
		camera = temp.camera
	else:
		camera = temp
	#camera = get_node_or_null(camera_path)

func _set_collsion_state(state : String) -> void:
	if current_collision_state != state:
		collision_player.play(state, -1, 10)
		current_collision_state = state

func on_jump_animation_finished():
	is_jumping = false
	
func _on_CatalogueControl_item_selected(item):
	_interact( {"item" : item} )
	
func _interact(params : Dictionary = {}) -> void:
	_set_active(false)
	interactor.interaction_finished.connect(_on_interaction_finished)
	interactor.interact(self, params)

func _on_interaction_finished(object):
	object.interaction_finished.disconnect(_on_interaction_finished)
	_set_active(true)

var node_test : Node = Node.new()
var mesh_test : Dictionary = {}
func _create_debug_mesh(key, color : Color):
	if key in mesh_test:
		return
	if mesh_test.empty():
		add_child(node_test)
	var instance = MeshInstance3D.new()
	var mesh : Mesh = BoxMesh.new()
	mesh.size = Vector3(0.2,0.2,0.2)
	instance.mesh = mesh
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	instance.set_surface_material(0,material )
	node_test.add_child(instance)
	mesh_test[key] = instance

func _debug(position : Vector3, key, color : Color = Color.white):
	_create_debug_mesh(key, color)
	mesh_test[key].global_transform.origin = position
	mesh_test[key].material_override.albedo_color = color
