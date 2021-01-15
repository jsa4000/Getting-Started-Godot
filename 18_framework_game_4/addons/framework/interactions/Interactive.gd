@tool
class_name Interactive extends Interactable
@icon("../icons/interactive.svg")

@export var enabled : bool = true
@export_node_path var actor_path : NodePath
@export var policy : Resource
@export var data : Dictionary= {}

var _collider : CollisionObject3D
var _actions : Array = []
var _actor : Node
var _blackboard : Dictionary = {}
var _initialized : bool = false

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() < 1:
		result.append("%s should have at least one child" % name)
	if policy == null:
		result.append("%s should have a policy" % name)
	return String("\n").join(result)

func _init():
	add_to_group(Interactions.INTERACTIVE_GROUP)

func _ready():
	_set_policy(policy)
	_set_actor_by_path(actor_path)
	_set_layer_mask(Interactions.INTERACTIVE_LAYER_MASK)
	if Engine.is_editor_hint():
		return
	call_deferred("_init_blackboard")
	
func _set_layer_mask(value : int) -> void:
	if _actor is PhysicsBody3D:
		_actor.set_collision_layer_bit(value, true)	
	
func _init_blackboard() -> void:
	# TODO Godot 4 throws an error when there is no item. Create aa Dummy key/value
	_blackboard = SelectionUtils.get_data_from_node(self, data)
	_initialized = true
	
func interact(entity: Node, parameters: Dictionary = {}) -> void: 
	if policy == null:
		return
	var interaction = policy.get_interaction()
	if interaction != null:
		self.interaction_started.emit(self)
		interaction.interaction_finished.connect(_on_interaction_finished)
		interaction.execute(_actor, entity, parameters,_blackboard)
	else:
		self.interaction_finished.emit(self)
		
func _on_interaction_finished(interaction):
	interaction.interaction_finished.disconnect(_on_interaction_finished)
	self.interaction_finished.emit(self)
			
func _set_actor_by_path(value : NodePath) -> void:
	_actor = get_node_or_null(value)
	if _actor == null:
		_actor = get_parent()

func _set_policy(value : Resource) -> void:
	if value != null && not Engine.is_editor_hint():
		value.init(self)

func _set_collision_layer(collider : CollisionObject3D, value : int) -> void:
	if collider != null:
		collider.set_collision_layer_bit(value, true)	
