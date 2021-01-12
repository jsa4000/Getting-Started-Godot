tool
extends Node
class_name Action

enum Error {NOT_ALLOWED, NOT_IMPLEMENTED, HANDLER_NOT_FOUND, UNKNOWN_ERROR, NONE}

const GROUP : String = "actions"

onready var logger : Logger = ServiceLocator.get_logger()

signal finished(action, error)

func _init():
	add_to_group(GROUP)

func execute() -> void:
	logger.error("Error. Method not implemented", self)
	emit_signal("finished", self,  Error.NOT_IMPLEMENTED)
