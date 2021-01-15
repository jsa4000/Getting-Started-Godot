@tool
extends VBoxContainer

@export var player_selection : Resource
@export var status_selection : Resource
@export var health_selection : Resource

var _player : Node
var _status : String
var _health : int

func _ready():
	if Engine.is_editor_hint():
		return
	call_deferred("_initialize")

func _initialize():
	_player = player_selection.get_object(self)
	_status = status_selection.get_object(self)
	_health = health_selection.get_object(self)
	_add_label("Player: %s" % _player.name)
	_add_label("Status: %s" % _status)
	_add_label("Health: %d" % _health)
	
func _add_label(item : String) -> void:
	var label = Label.new()
	label.text = item
	label.size_flags_horizontal = Control.SIZE_EXPAND
	add_child(label)


