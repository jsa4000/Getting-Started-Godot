tool
extends Node

const Logger = preload("../scripts/Logger.gd")

var current : Logger  = null

signal event(event)

func _ready():
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
	logger.connect("event", self, "_on_event")
	return logger

func _on_event(event):
	emit_signal("event", event)
