@tool
class_name TimeLogger extends Logger
@icon("../icons/icon.svg")

const DEFAULT_FORMAT : String ="%s | %5s | %s | %s"
const DATETIME_RFC3339 = "%04d-%02d-%02dT%02d:%02d:%02dZ"

@export_placeholder var format : String = DEFAULT_FORMAT

func _print(level: int, message: String, parameters : Dictionary = {}) -> void:
	print(format % [_get_datetime(OS.get_datetime()),log_levels[level], className , message])
			
func _get_datetime(time : Dictionary) -> String:
	return DATETIME_RFC3339 % [time["year"], time["month"], time["day"], time["hour"], time["minute"], time["second"]]
