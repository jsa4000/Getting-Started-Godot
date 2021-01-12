tool
extends BaseControl
class_name OpenFileControl

const FileDialogSize = Vector2(1000, 600)

var exports_definition = [
	{"name":"value", "type": TYPE_STRING, "setget": "set_value,get_value"},	
]

onready var _file_path = $FilePath
onready var _file_dialog = $FileDialog

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value() -> String:  
	return _file_path.text

func set_value(value : String): 
	_file_path.text = value
	emit_signal("value_changed", self, value)

func _on_Button_pressed():
	_file_dialog.popup_centered(FileDialogSize)

func _on_FileDialog_file_selected(path):
	_file_dialog.visible = false
	_file_path.text = path
	emit_signal("value_changed", self, get_value())

func _on_FilePath_focus_exited():
	emit_signal("value_changed", self, get_value())
