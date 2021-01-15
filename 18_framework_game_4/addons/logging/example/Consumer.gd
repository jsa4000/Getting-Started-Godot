extends ItemList

# TODO: Godot 4.0 GDScript Error using Logger as Type
#@onready var logger : Logger = LoggerManager.get_logger("Test")
@onready var logger = LoggerManager.get_logger("Consumer")

func _ready():
	logger.debug("Node is Ready")
	LoggerManager.event.connect(_on_event)

func _on_event(event_log : EventLog) -> void:
	add_item("%s" % event_log)
