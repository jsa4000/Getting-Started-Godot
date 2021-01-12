
tool
extends Node
class_name Executor

onready var logger : Logger = ServiceLocator.get_logger()

signal action_finished(action, error)

func size() -> int:
	logger.error("Error. Method not implemented", self)
	return 0

func execute() -> void:
	logger.error("Error. Method not implemented", self)
	emit_signal("action_finished",self, null)

func next() -> Action:
	logger.error("Error. Method not implemented", self)
	return null
	
func add(action: Action) -> void:
	logger.error("Error. Method not implemented", self)
