extends Debugger

@onready var logger = LoggerManager.get_logger("Debugger")

func _ready():
	super()
	#_start_logging(console.enabled)
	pass

func _on_event(event : EventLog):
	if event.type == "Log":
		console.append(str(event.payload.message))
	else:
		console.append(str(event))

# TODO: Godot super does not recogniza parent method
#func _on_ShowConsole_toggled(button_pressed):
#	super(button_pressed)
#	_start_logging(button_pressed)

func _start_logging(enabled : bool) -> void:
	if logger == null:
		return
	if enabled:
		LoggerManager.event.connect(_on_event)
		logger.info("Debugger connected to global events")
	else:
		logger.info("Debugger disconnected to global events")
		LoggerManager.event.disconnect(_on_event)
