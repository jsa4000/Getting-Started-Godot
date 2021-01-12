tool
extends BaseControl
class_name LabelControl

enum Align { LEFT, CENTER, RIGHT }

onready var _label : Label = $Label

var exports_definition = [
	{"name":"label/show", "path": "Label:visible", "type": TYPE_BOOL},
	{"name":"label/text", "path": "Label:text","type": TYPE_STRING},
	{"name":"label/align", "path": "Label:align","type": TYPE_INT, "values": PoolStringArray(Align.keys()).join(",")}  
]

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value(): return _label.text

func set_value(value): 
	_label.text = value
	emit_signal("value_changed", self, value)

