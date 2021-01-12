tool
extends Path
class_name Portal

enum DirectionType {RIGHT, LEFT}

export(DirectionType) var direction = DirectionType.RIGHT
export(NodePath) var transition_path
export(bool) var transition_enabled = false
export(NodePath) var chain_portal_start_path
export(NodePath) var chain_portal_end_path
export(PackedScene) var chain_scene_start
export(PackedScene) var chain_scene_end

onready var player : KinematicBody
onready var camera : Camera
onready var slider : CameraSlider
onready var areas = get_areas()
onready var transition = get_node(transition_path)
var chain_portal_start 
var chain_portal_end 

signal body_entered(portal, body, direction, transition)

func _get_configuration_warning():
	var warnings = PoolStringArray([])
	#if not areas || not areas.size():
	#	warnings.append("%s is missing an area to trigger camera movement. Consider adding an Area to define the collision shape" % name)
	if not curve:
		warnings.append("%s is missing a curve. Consider defining points to the curve" % name)
	if not check_curve_direction():
		warnings.append("Curves must start from left to right (x axis) so it matches with the direction")
	return warnings.join("\n")

func _ready():
	initialize()

func initialize():
	for area in areas:
		area.connect("actor_entered",self,"_on_actor_entered")
	if chain_portal_start_path:
		chain_portal_start = get_node(chain_portal_start_path)
	if chain_portal_end_path:
		chain_portal_end = get_node(chain_portal_end_path)
	
func check_curve_direction() -> bool:
	if curve && curve.get_point_count() && curve.get_point_position(0).x > curve.get_point_position(curve.get_point_count() - 1).x:
		return false
	return true	
	
func _on_actor_entered(body):
	if transition:
		transition.player = player
		transition.camera = camera
		transition.slider = slider
	emit_signal("body_entered", self, body, direction, transition)

func get_areas() -> Array:
	if(TreeUtils.is_inside_tree()):
		return TreeUtils.get_children_by_type(self, AreaDirectional)
	return []

