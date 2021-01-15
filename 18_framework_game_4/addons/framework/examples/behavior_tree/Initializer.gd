extends Node

var data = {
	"player" : {
		"repository" : "../BlackboardRepository",
		"key" : "player"
	},
	"points" : {
		"repository" : "../BlackboardRepository",
		"key" : "track"
	}
}

@export_node_path var behavior_tree : NodePath

@onready var _behavior_tree : BehaviorTree = get_node(behavior_tree)

func _ready():
	if Engine.is_editor_hint():
		return
	# TODO: In Godot 4.0 The 'Object' item in the selection types (Dictionary) does not work
	_init_behavior_tree()

func _init_behavior_tree():
	for item in data:
		var selection = SelectiondByRepository.new()
		# TODO : In Godot 4.0 the dictionary indexer does not work. data["repository"] or data.repository
		selection.repository_path = NodePath(data[item].get("repository"))
		selection.key_name = data[item].get("key")
		_behavior_tree.data[item] = selection
