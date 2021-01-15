@tool
extends Node

var current : Logger

signal event(event)

func _ready():
	_init_logger()

func _init_logger() -> void:
	var loggers = get_tree().get_nodes_in_group(Logger.GROUP_NAME) 
	# Get the last one added to the node tree, since it loops over all the nodes
	for logger in loggers: 
		if logger.current:
			current = logger
	if current == null:
		current = Logger.new()

func get_logger(className : String) -> Logger:
	var logger : Logger = current.duplicate()
	logger.className = className
	logger.event.connect(_on_event)
	return logger

func _on_event(event_log):
	event.emit(event_log)
