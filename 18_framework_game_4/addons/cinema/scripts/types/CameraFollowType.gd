@tool
class_name CameraFollowType extends CameraType

const PREDICTION_LENGTH_THRESHOLD = 0.01
const DeadZonePath := "res://addons/cinema/scripts/DeadZone.tscn"

var COLLISION_RAY_BIT_MASK : int = BIT(0) | BIT(2)

@export_node_path var target_path : NodePath
@export_node_path var lookat_path : NodePath
@export var show_dead_zone : bool = false #setget _set_show_dead_zone
@export var follow_enabled : bool = true
@export_range(0.0, 10.0) var smooth_zone_speed : float = 0.8
@export_range(0.0, 5.0) var dead_zone_speed : float = 0.4
@export var lookat_enabled : bool = false
@export var lookat_at_beginning : bool = false
@export_range(0.0, 10.0) var lookat_smooth_zone_speed : float = 0.5
@export_range(0.0, 5.0) var lookat_dead_zone_speed : float = 0.25
@export var lookat_offset : Vector3 = Vector3.ZERO
@export var smooth_zone : Rect2 = Rect2(Vector2(0.05,0.05),Vector2(0.9,0.9)) #setget _set_smooth_zone
@export var dead_zone : Rect2 = Rect2(Vector2(0.3,0.25),Vector2(0.4,0.5)) #setget _set_dead_zone
@export var zone_offset : Vector2 = Vector2.ZERO #setget _set_zone_offset
@export_range(0.0, 1.0) var transition_zone_speed : float = 0.1
@export var collision_enabled : bool = true
@export_range(0.0, 50.0) var collision_slope_speed : float = 30.0
@export_range(0.0, 1.0,0.0001) var collision_angle_threshold : float = 0.7
@export_range(0.0,10.0,0.0001) var collision_offset_position : float = 0.5

@export var prediction_enabled : bool = false
@export_range(0.0, 5.0) var prediction_scale : float = 1.25
@export_range(0.0, 2.0) var prediction_scale_speed : float = 0.2
@export_range(0.0, 1.0,0.0001) var prediction_threshold : float = PREDICTION_LENGTH_THRESHOLD
@export var debug_enabled : bool = false #setget _set_debug_enabled

var target
var target_mesh : MeshInstance3D
var lookat: Node3D
var _drawer : ShapeDrawer
var _dead_zone : DeadZone

var current_speed : float = 0.0
var current_lookat_speed : float = 0.0

var previous_position : Vector3 = Vector3.ZERO
var previous_lookat_position : Vector3 = Vector3.ZERO

var current_precision_scale : float = 0.0
var looked_activated : bool = false

func _ready() -> void:
	target = _parent.get_node(target_path)
	lookat = _parent.get_node(lookat_path)
	target_mesh = _get_target_mesh()
	_set_debug_enabled(debug_enabled)
	_set_show_dead_zone(show_dead_zone)

func _deactivate() -> void: 
	_enable_debug_drawer(false)
	_enable_dead_zone(false)
	looked_activated = false

func camera_process(delta: float) -> void:
	var viewport_size = gimbal.get_viewport().size
	var bound = ProjectionUtils.get_aabb_projection(target_mesh, gimbal.camera)
	
	_compute_current_speeds(delta, bound, viewport_size)
	
	if follow_enabled:
		var current_position = target.global_transform.origin + offset
		
		if collision_enabled:
			current_position = _compute_collisioned_position(current_position, collision_slope_speed * delta)
		
		var desired_position = current_position
		
		if prediction_enabled:
			desired_position = _compute_prediction_position(current_position, previous_position, delta )

		_translate(desired_position, current_speed * delta)
		previous_position = current_position
	else:
		gimbal.global_transform.origin = _parent.global_transform.origin
		
	if lookat_enabled:
		var current_lookat_position = lookat.global_transform.origin + lookat_offset
		
		if noise_enabled:
			current_lookat_position += _compute_noise_position(current_lookat_position) * noise_translation_amount
		
		var desired_lookat_position = current_lookat_position
		
		if prediction_enabled:
			desired_lookat_position = _compute_prediction_position(current_lookat_position, previous_lookat_position, delta )
	
		if lookat_at_beginning and not looked_activated:
			_look_at(current_lookat_position, 1.0)
			looked_activated = true
		else:
			_look_at(desired_lookat_position, current_lookat_speed * delta)
			
		if noise_enabled:
			gimbal.camera.rotation.z = _compute_noise_position(current_lookat_position).z * noise_rotation_amount
			
		previous_lookat_position = current_lookat_position
	else:
		gimbal.global_transform.basis = _parent.global_transform.basis
	
	_fov(camera_fov, camera_fov_speed * delta)
	
	if debug_enabled:
		_draw_debug(bound, viewport_size)

func _compute_prediction_position(current_position: Vector3, previous_position : Vector3, delta: float) -> Vector3:
	var direction = previous_position - current_position
	if direction.length() > prediction_threshold:
		current_precision_scale = lerp(current_precision_scale, prediction_scale, prediction_scale_speed * delta)
		return current_position - (direction.normalized() * current_precision_scale)
	current_precision_scale = 0.0
	return current_position

func _compute_collisioned_position(position: Vector3, speed : float) -> Vector3:
	var result = position
	
	var from = gimbal.global_transform.origin
	var to = from + Vector3(0,-offset.y, 0)
	var collision = _raycast(from, to)
	if not collision.is_empty():
		# TOOO: Godot 4.0 does not allow use indexes in dictionariess
		#result.y = lerp(position.y, collision.position.y + offset.y, speed)
		result.y = lerp(position.y, collision.get("position").y + offset.y, speed)
	
	from = position - Vector3(offset.x, 0.0, offset.z)
	to = gimbal.global_transform.origin
	collision = _raycast(from, to)
	# TOOO: Godot 4.0 does not allow use indexes in dictionariess
#	if not collision.is_empty() && not collision.collider is KinematicBody3D:
#		if abs(collision.normal.dot(Vector3.UP)) < collision_angle_threshold:
#			#result.z = collision.position.z - collision_offset_position
#			result.z = collision.position.z
	if not collision.is_empty() && not collision.get("collider") is KinematicBody3D:
		if abs(collision.get("normal").dot(Vector3.UP)) < collision_angle_threshold:
			result.z = collision.get("position").z
		
	return result
	
func _raycast(from: Vector3, to: Vector3) -> Dictionary:
	var space_state = gimbal.get_viewport().world_3d.direct_space_state 
	return space_state.intersect_ray(from, to, [gimbal], 2147483647, true, false)
	
func _compute_current_speeds(delta: float, bound : Rect2, viewport_size : Vector2) -> void:
	if is_in_smooth_zone(bound, viewport_size):
		current_speed = lerp(current_speed, smooth_zone_speed, transition_zone_speed * delta)
		current_lookat_speed = lerp(current_lookat_speed, lookat_smooth_zone_speed, transition_zone_speed * delta)
	else:
		current_speed = lerp(current_speed, dead_zone_speed, transition_zone_speed * delta)
		current_lookat_speed = lerp(current_lookat_speed, lookat_dead_zone_speed, transition_zone_speed * delta)

func _translate(target: Vector3, speed: float) -> void:
	gimbal.global_transform.origin = gimbal.global_transform.origin.lerp(target, speed)
		
func _look_at(target: Vector3, speed: float) -> void:
	var xform = gimbal.camera.global_transform.looking_at(target, Vector3.UP)
	gimbal.camera.global_transform.basis = gimbal.camera.global_transform.basis.slerp(xform.basis, speed)
	
func is_in_smooth_zone(bound : Rect2, viewport_size : Vector2)-> bool:
	var sz = _get_fixed_rect(smooth_zone, zone_offset, viewport_size)
	var dz = _get_fixed_rect(dead_zone, zone_offset, viewport_size)
	if _intersects(bound,sz, false) && not _intersects(dz,bound, true):
		return true
	return false
		
func _draw_debug(bound : Rect2, viewport_size : Vector2) -> void:
	var sz = _get_fixed_rect(smooth_zone,zone_offset, viewport_size)
	var dz = _get_fixed_rect(dead_zone,zone_offset, viewport_size)
	_drawer.clear()
	_drawer.append(sz, Color(0.0,1.0,0.0,0.5))
	_drawer.append(dz, Color(1.0,0.0,0.0,0.5))
	_drawer.append(bound, Color(0.0,0.0,1.0,0.5))
	
func _intersects(a : Rect2, b : Rect2, fully : bool) -> bool:
	if fully:
		return a.position.x <= b.position.x && a.position.y <= b.position.y && a.end.x >= b.end.x && a.end.y >= b.end.y
	else:
		return not (a.end.x < b.position.x || a.position.x > b.end.x || a.end.y < b.position.y || a.position.y > b.end.y)

func _get_fixed_rect(zone : Rect2, offset : Vector2, viewport_size : Vector2) -> Rect2:
	return Rect2((zone.position + offset) * viewport_size, zone.size * viewport_size)

func _set_debug_enabled(value : bool) -> void:
	debug_enabled = value
	_enable_debug_drawer(value)
		
func _set_show_dead_zone(value : bool) -> void:
	show_dead_zone = value
	_enable_dead_zone(value)
	
func _set_smooth_zone(value : Rect2) -> void:
	smooth_zone = value
	_set_dead_zone_properties()
	
func _set_dead_zone(value : Rect2) -> void:
	dead_zone = value
	_set_dead_zone_properties()
	
func _set_zone_offset(value : Vector2) -> void:
	zone_offset = value
	_set_dead_zone_properties()

func _set_dead_zone_properties() -> void:
	if _dead_zone == null:
		return
	_dead_zone.smooth_zone = smooth_zone
	_dead_zone.dead_zone = dead_zone
	_dead_zone.offset = zone_offset
	print("Setting the taget mesh")
	print(target_mesh)
	if target_mesh != null:
		_dead_zone.target = target_mesh

func _has_member(name: String, object: Object) -> bool:
	return name in object

func _enable_debug_drawer(enabled: bool) -> void:
	if gimbal == null:
		return
	if _drawer != null:
		gimbal.remove_child(_drawer)
		_drawer.queue_free()
		_drawer = null
	if enabled:
		_drawer = ShapeDrawer.new()
		gimbal.add_child(_drawer)
		
func _enable_dead_zone(enabled: bool) -> void:
	if gimbal == null:
		return
	if _dead_zone != null:
		gimbal.remove_child(_dead_zone)
		_dead_zone.queue_free()
		_dead_zone = null
	if enabled:
		_dead_zone = load(DeadZonePath).instance()
		gimbal.add_child(_dead_zone)
		_set_dead_zone_properties()
		_dead_zone.enabled = enabled

func _get_target_mesh() -> MeshInstance3D:
	if target is MeshInstance3D:
		return target
	elif "mesh" in target:
		return target.mesh
	return null	
	
static func BIT(n : int) -> int:
	return 1 << n
