tool
extends BaseControl
class_name TestControl

enum Align { LEFT, CENTER, RIGHT }

export(bool) var enabled : bool = false
export(String) var text : String

var color
onready var _label : LineEdit = $Label

var exports_definition = [
	{"name":"label/hide", "type": TYPE_BOOL, "setget": "set_label_hide,get_label_hide"},
	{"name":"label/text", "path": "Label:text","type": TYPE_STRING},
	{"name":"label/align", "path": "Label:align","type": TYPE_INT, "values": PoolStringArray(Align.keys()).join(",")},
	{"name":"label/editable", "path": "Label:editable","type": TYPE_BOOL},
	{"name":"color", "path": "color","type": TYPE_COLOR},
	{"name":"is_visible", "path": "visible","type": TYPE_BOOL}      
]

func set_label_hide(value): 
	if not is_inside_tree() || not _label:
		return
	_label.visible = !value
	
func get_label_hide(): 
	if not is_inside_tree() || not _label:
		return
	return !_label.visible

func _ready():
	pass

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value(): return _label.text

func set_value(value): 
	_label.text = value
	emit_signal("value_changed", self, value)

