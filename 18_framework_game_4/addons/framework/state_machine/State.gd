@tool
class_name State extends Node
@icon("../icons/state.svg")

@export_placeholder var state_name : String
@export var start : bool = false
@export var end : bool = false

var _transitions : Array = []
var _actor : Node

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() < 1 && not start && not end:
		result.append("%s should have at least one child" % name)
	return String("\n").join(result)

func _ready():
	_set_state_name(state_name)
	call_deferred("_init_transitions")
	
func _init_transitions() -> void:
	_transitions.clear()
	for node in get_children():
		if node is Transition:
			_transitions.append(node)

# TODO: Issue with Godot 4.0 recognizing class_name
func get_transition(blackboard : Dictionary) : #-> State:
	for transition in _transitions:
		if transition.condition(_actor, blackboard):
			return transition.state
	return null

func enter(actor : Node) -> void:
	_actor = actor
	
func exit() -> void: pass
	
func update(blackboard : Dictionary) -> void: pass
	
func handle() -> void : pass

func _set_state_name(value : String) -> void:
	if value.is_empty():
		state_name = name
