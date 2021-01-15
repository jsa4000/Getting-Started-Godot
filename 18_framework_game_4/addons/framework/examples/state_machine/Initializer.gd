@tool
extends Node

var state_machine_data = {
	"player" : {
		"repository" : "../BlackboardRepository",
		"key" : "player"
	},
	"start_position" : {
		"repository" : "../BlackboardRepository",
		"key" : "start_position"
	}
}

@export_node_path var state_machine : NodePath

@onready var _state_machine : StateMachine = get_node(state_machine)

func _ready():
	if Engine.is_editor_hint():
		return
	# TODO: In Godot 4.0 The 'Object' item in the selection types (Dictionary) does not work
	_init_state_machine()

func _init_state_machine():
	for item in state_machine_data:
		var data = state_machine_data[item]
		var selection = SelectiondByRepository.new()
		# TODO : In Godot 4.0 the dictionary indexer does not work. data["repository"] or data.repository
		selection.repository_path = NodePath(data.get("repository"))
		selection.key_name = data.get("key")
		_state_machine.data[item] = selection
