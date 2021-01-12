extends InteractionPolicy
class_name InteractionStatePolicy

export(Array, Resource) var subscriptions : Array
export(Dictionary) var states : Dictionary

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
		node.connect(sub.signal_name, self, "_on_state_changed")

func _on_state_changed(state):
	_current_state = state
