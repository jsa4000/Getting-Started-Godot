@tool
class_name Logger extends Node
@icon("../icons/icon.svg")

const LOG_EVENT : String = "Log"
const GROUP_NAME : String = "logging"
const DEFAULT_CLASSNAME : String = "Logger"

enum LogLevel {DEBUG = 0, INFO, WARN, ERROR, FATAL}

@export var current : bool = true
# TODO: Godot 4.0 does not support enums typees (LogLevel)
@export var level : int = LogLevel.DEBUG
@export_placeholder var className : String = DEFAULT_CLASSNAME

var log_levels : Dictionary

signal event(event)

func _init():
	add_to_group(GROUP_NAME)
	# TODO Godot 4.0 does not provide keys functionality to loop over the enums
	log_levels = _convert_enum(LogLevel)

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
	
func send(type: String, payload : Dictionary = {}) -> void:
	_send(type, payload)
		
func _trace(level: int, message: String, parameters : Dictionary = {}) -> void:
	if self.level <= level:
		_print(level, message, parameters)
		_send(LOG_EVENT, _get_payload(level, message, parameters))

func _print(level: int, message: String, parameters : Dictionary = {}) -> void:
	print("%5s | %s | %s" % [log_levels[level], className , message])
	
func _send(type : String, payload : Dictionary) -> void:
	event.emit(EventLog.new(type,payload))
	
func _get_payload(level: int, message: String, parameters : Dictionary = {}) -> Dictionary:
	return {
		"level" : level,
		"message" : message,
		"parameters" : parameters
	}

func _convert_enum(enums) -> Dictionary:
	var result : Dictionary = {}
	var enum_str = "%s" % LogLevel
	var tokens = enum_str.substr(1, enum_str.length() - 2).split(",")
	for token in tokens:
		var key_value = token.split(":")
		result[key_value[1].to_int()] = key_value[0].replace(" ","")
	return result
	
