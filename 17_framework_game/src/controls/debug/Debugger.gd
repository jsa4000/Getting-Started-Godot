extends Debugger

onready var logger = LoggerManager.get_logger("Debugger")

func _ready():
	_start_logging(console.enabled)

func _on_event(event : EventLog):
	if event.type == "Log":
		console.append(str(event.payload.message))
	else:
		console.append(str(event))

func _on_ShowConsole_toggled(button_pressed):
	._on_ShowConsole_toggled(button_pressed)
	_start_logging(button_pressed)

func _start_logging(enabled : bool) -> void:
	if logger == null:
		return
	if enabled:
		LoggerManager.connect("event", self, "_on_event")
		logger.info("Debugger connected to global events")
	else:
		logger.info("Debugger disconnected to global events")
		LoggerManager.disconnect("event", self, "_on_event")
