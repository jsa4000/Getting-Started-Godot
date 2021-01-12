tool
extends Interactable
class_name Interactive, "../icons/interactive.svg"

export (bool) var enabled = true
export(NodePath) var actor_path : NodePath setget _set_actor_path
export(Resource) var policy : Resource setget _set_policy
export(Dictionary) var data = {}

var _collider : CollisionObject
var _actions : Array = []
var _actor : Node
var _blackboard : Dictionary = {}
var _initialized : bool = false

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() < 1:
		result.append("%s should have at least one child" % name)
	if policy == null:
		result.append("%s should have a policy" % name)
	return result.join("\n")

func _init():
	add_to_group(Interactions.INTERACTIVE_GROUP)

func _ready():
	_set_actor_path(actor_path)
	if Engine.is_editor_hint():
		return
	call_deferred("_init_blackboard")
	
func _init_blackboard() -> void:
	_blackboard = SelectionUtils.get_data_from_node(self, data)
	_initialized = true
	
func interact(entity: Node, parameters: Dictionary = {}) -> void: 
	if policy == null:
		return
	var interaction = policy.get_interaction()
	if interaction != null:
		emit_signal("interaction_started", self)
		interaction.connect("interaction_finished", self, "_on_interaction_finished")
		interaction.execute(_actor, entity, parameters,_blackboard)
	else:
		emit_signal("interaction_finished", self)
		
func _on_interaction_finished(interaction):
	interaction.disconnect("interaction_finished", self, "_on_interaction_finished")
	emit_signal("interaction_finished", self)
			
func _set_actor_path(value : NodePath) -> void:
	actor_path = value
	if not is_inside_tree():
		return
	_actor = get_node_or_null(actor_path)
	if _actor == null:
		_actor = get_parent()
		if _actor != null:
			actor_path = _actor.get_path()

func _set_policy(value : Resource) -> void:
	policy = value
	if policy != null && not Engine.is_editor_hint():
		policy.init(self)

func _set_collision_layer(collider : CollisionObject, value : int) -> void:
	if collider != null:
		collider.set_collision_layer_bit(value, true)	
