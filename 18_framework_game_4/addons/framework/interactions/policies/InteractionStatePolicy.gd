class_name InteractionStatePolicy extends InteractionPolicy

# TOOO. Godot 4.0 is not allowed to specify item Type for the arrays (Resource)
# TODO. Godot 4.0 Variables must be initialized. By default are set to Nil
@export var subscriptions : Array = []
@export var states : Dictionary = {}

var _state_mananger : Node
var _current_state : String

func _ready():
	call_deferred("_init_subscriptions")

func get_interaction() -> Interaction:
	if _current_state in states:
		return _parent.get_node(states[_current_state]) as Interaction
	return null
	
func _init_subscriptions():
	for sub in subscriptions:
		var node = _parent.get_node(sub.node_path)
		# TODO: JSA400 to see how it can be made
		#node.connect(sub.signal_name, self, "_on_state_changed")

func _on_state_changed(state):
	_current_state = state
