tool
extends BaseControl
class_name TextEditControl

export (String) var value : String = "" setget set_value, get_value
export (bool) var readonly : bool= false setget _set_readonly

onready var _text : TextEdit = $Text

func _ready():	
	set_value(value)

func get_value() -> String:  
	return value

func set_value(val : String): 	
	value = val
	if _text != null:
		_text.text = value
	emit_signal("value_changed", self, value)
	
func _set_readonly(value: bool) -> void:
	readonly = value
	if _text != null:
		_text.readonly = readonly

func _on_Text_focus_exited():
	value = _text.text
	emit_signal("value_changed", self, get_value())
