@tool
class_name TextEditControl extends BaseControl

var value : String = "":
	set = set_value, get = get_value
	
@export var readonly : bool= false #setget _set_readonly

@onready var _text : TextEdit = $Text

func _ready():	
	super()
	set_value(value)

func get_value() -> String:  
	return value

func set_value(val : String): 	
	if value == val:
		return
	value = val
	if _text != null:
		_text.text = value
	self.value_changed.emit(self, value)
	
func _set_readonly(value: bool) -> void:
	readonly = value
	if _text != null:
		_text.readonly = readonly

func _on_Text_focus_exited():
	value = _text.text
