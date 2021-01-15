@tool
class_name BehaviorTree extends Node
@icon("../icons/tree.svg")

@export var enabled : bool = true
@export_node_path var actor_path : NodePath
@export var data : Dictionary = {}

var _actor : Node
var _blackboard : Dictionary = {}
var _initialized : bool = false

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() < 1:
		result.append("%s should have at least one child" % name)
	return String("\n").join(result)

func _init():
	add_to_group(BehaviorTreeGlobal.BEHAVIOR_TREE_GROUP)

func _ready():
	_set_enabled(enabled)
	_set_actor_by_path(actor_path)
	if Engine.is_editor_hint():
		return
	call_deferred("_init_blackboard")

func _physics_process(delta):
	if not enabled || get_child_count() == 0 || Engine.is_editor_hint() || not _initialized:
		return

	_blackboard["delta"] = delta
	get_child(0).eval(_actor, _blackboard)

func _set_enabled(value : bool) -> void:
	set_process(value)
	set_physics_process(value)

func _init_blackboard() -> void:
	_blackboard = SelectionUtils.get_data_from_node(self, data)
	_initialized = true

func _set_actor_by_path(value : NodePath) -> void:
	_actor = get_node_or_null(value)
	if _actor == null:
		_actor = get_parent()
