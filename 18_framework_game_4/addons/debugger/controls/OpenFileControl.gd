@tool
class_name OpenFileControl extends BaseControl

const FileDialogSize = Vector2(1000, 600)

var value : String:
	set = set_value, get = get_value

@onready var _file_path = $FilePath
@onready var _file_dialog = $FileDialog

func _ready():
	super()
	set_value(value)

func get_value() -> String:  
	return value

func set_value(val : String): 
	if value == val:
		return
	value = val
	if _file_path != null:
		_file_path.text = value
	self.value_changed.emit(self, value)

func _on_Button_pressed():
	_file_dialog.popup_centered(FileDialogSize)

func _on_FileDialog_file_selected(path):
	_file_dialog.visible = false
	value = path
	_file_path.text = path

func _on_FilePath_focus_exited():
	self.value_changed.emit(self, get_value())
