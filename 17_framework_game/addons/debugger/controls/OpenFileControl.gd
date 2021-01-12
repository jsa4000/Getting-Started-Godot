tool
extends BaseControl
class_name OpenFileControl

const FileDialogSize = Vector2(1000, 600)

export (String) var value : String setget set_value, get_value

onready var _file_path = $FilePath
onready var _file_dialog = $FileDialog

func _ready():
	set_value(value)

func get_value() -> String:  
	return value

func set_value(val : String): 
	value = val
	if _file_path != null:
		_file_path.text = value
	emit_signal("value_changed", self, value)

func _on_Button_pressed():
	_file_dialog.popup_centered(FileDialogSize)

func _on_FileDialog_file_selected(path):
	_file_dialog.visible = false
	value = path
	_file_path.text = path
	emit_signal("value_changed", self, get_value())

func _on_FilePath_focus_exited():
	emit_signal("value_changed", self, get_value())
