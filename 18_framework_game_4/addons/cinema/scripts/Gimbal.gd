@tool
class_name Gimbal extends KinematicBody3D
@icon("../icons/gimbal.svg")

#@export var current : bool = true setget _set_current
@export var current : bool = true:
	set = _set_current
	
@export_node_path var camera_path

#@export_range(0,10) var height : float = 0.0  #setget _set_height
var height : float = 0.0:
	set = _set_height

#@export var collision : bool = false #setget _set_collision
var collision : bool = false:
	set = _set_collision

@export_node_path var collider_path #setget _set_collider_path
@export var motion_blur_enabled : bool = false #setget _set_motion_blur_enabled
@export_node_path var motion_blur_path

@onready var camera: Camera3D = get_node(camera_path)
@onready var motion_blur : MotionBlur = get_node(motion_blur_path)
@onready var pivot : Node3D = $Pivot
@onready var collider : CollisionShape3D

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
			
func _set_height(value : float) -> void:
	height = value
	if pivot != null:
		pivot.translation = Vector3(0,height,0)
