tool
extends KinematicBody
class_name Gimbal, "../icons/gimbal.svg"

export (bool) var current : bool = true setget _set_current
export(NodePath) var camera_path
export(float,0,10) var height : float = 1.3  setget _set_height
export (bool) var collision : bool = false setget _set_collision
export(NodePath) var collider_path setget _set_collider_path
export (bool) var motion_blur_enabled : bool = false setget _set_motion_blur_enabled
export(NodePath) var motion_blur_path

onready var camera: Camera = get_node(camera_path)
onready var motion_blur : MotionBlur = get_node(motion_blur_path)
onready var pivot : Spatial = $Pivot
onready var collider : CollisionShape

var velocity := Vector3.ZERO
var direction := Vector3.ZERO

func _ready() -> void:
	_set_current(current)
	_set_height(height)
	_set_collider_path(collider_path)
	_set_collision(collision)
	
func _set_current(value) -> void:
	current = value
	if camera != null:
		camera.current = current

func _set_collision(enabled : bool) -> void:
	collision = enabled
	if collider != null:
		collider.disabled = !enabled
		collider.visible = enabled
		
func _set_motion_blur_enabled(value : bool) -> void:
	motion_blur_enabled = value
	if motion_blur != null:
		motion_blur.enabled = value

func _set_collider_path(value : NodePath) -> void:
	collider_path = value
	if not collider_path.is_empty():
		collider = get_node_or_null(collider_path)
		if collider != null:
			_set_collision(collision)
			
func _set_height(value : float) -> void:
	height = value
	if pivot != null:
		pivot.translation = Vector3(0,height,0)
