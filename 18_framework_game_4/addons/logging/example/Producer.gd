extends Node

# TODO: Godot 4.0 GDScript Error using Logger as Type
#@onready var logger : Logger = LoggerManager.get_logger("Test")
@onready var logger = LoggerManager.get_logger("Producer")

func _ready():
	logger.debug("Node is Ready")

func _unhandled_input(event):
	if event is InputEventKey:
		logger.debug(OS.get_keycode_string(event.keycode))
		if event.pressed and event.keycode == KEY_D:
			logger.info("Switched to Debug Level")
			logger.level = Logger.LogLevel.DEBUG
		elif event.pressed and event.keycode == KEY_I:
			logger.info("Switched to Info Level")
			logger.level = Logger.LogLevel.INFO
		elif event.pressed and event.keycode == KEY_W:
			logger.info("Switched to Warn Level")
			logger.level = Logger.LogLevel.WARN
		elif event.pressed and event.keycode == KEY_E:
			logger.info("Switched to Error Level")
			logger.level = Logger.LogLevel.ERROR
		elif event.pressed and event.keycode == KEY_F:
			logger.info("Switched to Fatal Level")
			logger.level = Logger.LogLevel.FATAL
		elif event.pressed:
			logger.debug("This is a debug message")
			logger.info("This is an info message")
			logger.warn("This is a warn message")
			logger.error("This is an error message")
			logger.fatal("This is a fatal message")
	
