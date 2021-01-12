tool
extends Node
class_name Logger, "../icons/icon.svg"

const LOG_EVENT : String = "Log"
const GROUP_NAME : String = "logging"
const DEFAULT_CLASSNAME : String = "Logger"

enum LogLevel {DEBUG = 0, INFO, WARN, ERROR, FATAL}

export(bool) var current : bool = true
export(LogLevel) var level : int = LogLevel.DEBUG
export(String) var className : String = DEFAULT_CLASSNAME

signal event(event)

func _init():
	add_to_group(GROUP_NAME)

func debug(message : String, parameters : Dictionary = {}) -> void:
	_trace(LogLevel.DEBUG, message, parameters)
		
func info(message : String, parameters : Dictionary = {}) -> void:
	_trace(LogLevel.INFO, message, parameters)
		
func warn(message : String, parameters : Dictionary = {}) -> void:
	_trace(LogLevel.WARN, message, parameters)
		
func error(message : String, parameters : Dictionary = {}) -> void:
	_trace(LogLevel.ERROR, message, parameters)
		
func fatal(message: String, parameters : Dictionary = {}) -> void:
	_trace(LogLevel.FATAL, message, parameters)
	
func event(type: String, payload : Dictionary = {}) -> void:
	_send(type, payload)
		
func _trace(level: int, message: String, parameters : Dictionary = {}) -> void:
	if self.level <= level:
		_print(level, message, parameters)
		_send(LOG_EVENT, _get_payload(level, message, parameters))
		
func _print(level: int, message: String, parameters : Dictionary = {}) -> void:
	print("%5s | %s | %s" % [LogLevel.keys()[level], className , message])
	
func _send(type : String, payload : Dictionary) -> void:
	emit_signal("event", EventLog.new(type,payload))
	
func _get_payload(level: int, message: String, parameters : Dictionary = {}) -> Dictionary:
	return {
		"level" : level,
		"message" : message,
		"parameters" : parameters
	}

