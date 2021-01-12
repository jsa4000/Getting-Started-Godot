tool
extends Node
class_name BehaviorTree, "../icons/tree.svg"

export (bool) var enabled = true setget _set_enabled
export(NodePath) var actor_path : NodePath setget _set_actor_path
export(Dictionary) var data = {}

var _actor : Node
var _blackboard : Dictionary = {}
var _initialized : bool = false

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() < 1:
		result.append("%s should have at least one child" % name)
	return result.join("\n")

func _init():
	add_to_group(BehaviorTreeGlobal.BEHAVIOR_TREE_GROUP)

func _ready():
	_set_enabled(enabled)
	_set_actor_path(actor_path)
	if Engine.is_editor_hint():
		return
	call_deferred("_init_blackboard")

func _physics_process(delta):
	if not enabled || get_child_count() == 0 || Engine.is_editor_hint() || not _initialized:
		return

	_blackboard["delta"] = delta
	get_child(0).eval(_actor, _blackboard)

func _set_enabled(value : bool) -> void:
	enabled = value
	set_process(enabled)
	set_physics_process(enabled)

func _init_blackboard() -> void:
	_blackboard = SelectionUtils.get_data_from_node(self, data)
	_initialized = true

func _set_actor_path(value : NodePath) -> void:
	actor_path = value
	if not is_inside_tree():
		return
	_actor = get_node_or_null(actor_path)
	if _actor == null:
		_actor = get_parent()
		if _actor != null:
			actor_path = _actor.get_path()
