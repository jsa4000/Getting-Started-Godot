@tool
class_name DeadZone extends MeshInstance3D

const ANCHOR_SIZE := Vector3(0.2,0.2,0.2)
const SHAPE_COLOR := Color(0.0,0.0,1.0,0.5)

@onready var logger = LoggerManager.get_logger("DeadZone")

#@export var enabled : bool = false #setget _set_enabled
var enabled : bool = false:
	set = _set_enabled

@export var smooth_zone : Rect2 = Rect2(Vector2(0.1,0.1),Vector2(0.8,0.8)) #setget _set_smooth_zone
@export var dead_zone : Rect2 = Rect2(Vector2(0.4,0.4),Vector2(0.2,0.2))#setget _set_dead_zone
@export var offset : Vector2 = Vector2.ZERO #setget _set_offset
@export_node_path var target_path : NodePath

var _anchors = []
var target : MeshInstance3D
var _drawer : ShapeDrawer
var _material : ShaderMaterial = get_surface_material(0)

func _ready() -> void:
	_set_enabled(enabled)
	_init_shader()
	_init_anchors() 
	_init_drawer()
	#_init_target()

func _init_shader():
	_set_smooth_zone(smooth_zone)
	_set_dead_zone(dead_zone)
	_set_offset(offset)

func _init_target():
	target = get_node_or_null(target_path)

func _init_drawer() -> void:
		_drawer = ShapeDrawer.new()
		add_child(_drawer)

func _init_anchors() -> void:
	var cube : BoxMesh = BoxMesh.new()
	cube.size = ANCHOR_SIZE
	for i in range(ProjectionUtils.AABB_ENDPOINTS_COUNT):
		var mesh = MeshInstance3D.new()
		mesh.mesh = cube.duplicate()
		mesh.top_level = true
		_anchors.append(mesh)
		add_child(mesh)

func _process(delta) -> void:
	if Engine.is_editor_hint():
		return
	if target == null:
		return
		
	var points = ProjectionUtils.get_aabb_from_mesh(target)
	for i in range(ProjectionUtils.AABB_ENDPOINTS_COUNT):
		_anchors[i].global_transform.origin = points [i]
	
	var projections = ProjectionUtils.get_camera_projections(points, get_viewport().get_camera())
	var rect = ProjectionUtils.get_rect_from_projection(projections)	
	
	_drawer.clear()
	_drawer.append(rect, SHAPE_COLOR)

func _set_enabled(value : bool) -> void:
	enabled = value
	visible = value
	set_process(enabled)
	
func _set_smooth_zone(value : Rect2) -> void:
	smooth_zone = value
	if _material != null:
		_material.set_shader_param("smooth_zone", value)

func _set_dead_zone(value : Rect2) -> void:
	dead_zone = value
	if _material != null:
		_material.set_shader_param("dead_zone", value)

func _set_offset(value : Vector2) -> void:
	offset = value
	if _material != null:
		_material.set_shader_param("offset", value)
