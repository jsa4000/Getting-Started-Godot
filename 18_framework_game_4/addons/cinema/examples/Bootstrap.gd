@tool
extends Node

@export var transition_01 : Resource
@export var transition_02 : Resource

@export_node_path var cinema : NodePath
var _cinema : Cinema

@onready var _transitions : Array = [transition_01, transition_02]

func _ready():
	call_deferred("_init_transitions") 

func _init_transitions():
	var _cinema = get_node(cinema)
	if not _cinema.transitions.is_empty():
		return
	for transition in _transitions:
		_cinema.transitions.append(transition)
