extends Node
class_name Logger

const GROUP : String = "loggers"
const FORMAT : String = "%5s | %s | %s"

enum Mode {DEBUG, INFO, WARN, ERROR}

export(Mode) var mode = Mode.DEBUG
export(bool) var is_current = true

func _init():
	add_to_group(GROUP)

func debug(text, object = null):
	if mode <= Mode.DEBUG:
		print(FORMAT % [Mode.keys()[Mode.DEBUG], object.name if object else "", text ])
		
func info(text, object = null):
	if mode <= Mode.INFO:
		print(FORMAT % [Mode.keys()[Mode.INFO], object.name if object else "", text ])
		
func warn(text, object = null):
	if mode <= Mode.WARN:
		print(FORMAT % [Mode.keys()[Mode.WARN], object.name if object else "", text ])

func error(text, object = null):
	if mode <= Mode.ERROR:
		assert(text)
		print(FORMAT % [Mode.keys()[Mode.ERROR], object.name if object else "", text ])
