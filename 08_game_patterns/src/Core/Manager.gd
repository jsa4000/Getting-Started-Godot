tool
extends Node
class_name Manager

const GROUP : String = "managers"
export(bool) var is_current = false

onready var logger : Logger = ServiceLocator.get_logger()

func _init():
	add_to_group(GROUP)
