extends Logger
class_name LoggerDateTime

const DATETIME_FORMAT : String = "%s | %5s | %s | %s"
const DATETIME_RFC3339 = "%04d-%02d-%02dT%02d:%02d:%02dZ"

func _init():
	add_to_group(GROUP)

func debug(text, object = null):
	if mode <= Mode.DEBUG:
		print(DATETIME_FORMAT % [_get_datetime(), Mode.keys()[Mode.DEBUG], object.name if object else "", text ])
		
func info(text, object = null):
	if mode <= Mode.INFO:
		print(DATETIME_FORMAT % [_get_datetime(), Mode.keys()[Mode.INFO], object.name if object else "", text ])
		
func warn(text, object = null):
	if mode <= Mode.WARN:
		print(DATETIME_FORMAT % [_get_datetime(), Mode.keys()[Mode.WARN], object.name if object else "", text ])

func error(text, object = null):
	if mode <= Mode.ERROR:
		assert(text)
		print(DATETIME_FORMAT % [_get_datetime(), Mode.keys()[Mode.ERROR], object.name if object else "", text ])

func _get_datetime() -> String:
	var time = OS.get_datetime()
	return DATETIME_RFC3339 % [time["year"], time["month"], time["day"], time["hour"], time["minute"], time["second"]]
