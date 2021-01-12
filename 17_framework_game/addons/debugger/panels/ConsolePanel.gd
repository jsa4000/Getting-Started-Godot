extends PanelContainer
class_name ConsolePanel

const DEFAULT_TEXT : String= "Debug Console Started..."
const DEFAULT_MAX_LINES : int = 100
const NEW_LINE : String = "\n"

export (bool) var enabled : bool = true
export (String) var initial_text : String = DEFAULT_TEXT
export (int) var max_lines : int = DEFAULT_MAX_LINES

onready var _label = $Label

func _ready():
	append(initial_text)
	
func append(text : String) -> void:
	_check_max_lines()
	_label.text += text + NEW_LINE
	_label.scroll_vertical = DEFAULT_MAX_LINES

func _check_max_lines():
	if _label.text.count(NEW_LINE) > max_lines:
		_label.text = _label.text.substr(len(_label.text) / 2)

