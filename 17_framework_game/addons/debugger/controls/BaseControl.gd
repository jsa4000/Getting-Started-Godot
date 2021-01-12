tool
extends HBoxContainer
class_name BaseControl

signal value_changed(control, value)	

enum Align { LEFT, RIGHT }

export(bool) var hide_label: bool = false setget _set_hide_label
export(String) var text_label : String setget _set_text_label
export(Align) var align_label = Align.LEFT setget _set_align_label
export(Vector2) var min_size_label = Vector2.ZERO setget _set_min_size_label
export(int) var flags_label = SIZE_EXPAND_FILL setget _set_flags_label

onready var _label : Label = $Label
var id : int

func initialize(): pass
func get_value(): return null
func set_value(value): pass
func save_data() -> Dictionary: return {}
func load_data(data : Dictionary):  pass

func _ready():
	_set_hide_label(hide_label)
	_set_text_label(text_label)
	_set_align_label(align_label)
	_set_flags_label(flags_label)
	_set_min_size_label(min_size_label)

func _set_hide_label(value : bool):
	hide_label = value
	if not is_inside_tree() || not _label:
		return
	if hide_label:
		_label.hide()
	else:
		_label.show()

func _set_text_label(value : String):
	text_label = value
	if not is_inside_tree() || not _label:
		return
	_label.text = text_label

func _set_align_label(value : int):
	align_label = value
	if not is_inside_tree() || not _label:
		return
	if align_label == Align.LEFT:
		_label.align = Label.ALIGN_LEFT
	else:
		_label.align = Label.ALIGN_RIGHT
	
func _set_flags_label(value : int):
	flags_label = value
	if not is_inside_tree() || not _label:
		return
	_label.size_flags_horizontal = flags_label

func _set_min_size_label(value : Vector2):
	min_size_label = value
	if not is_inside_tree() || not _label:
		return
	if min_size_label == Vector2.ZERO:
		_label.autowrap = false
	else:
		_label.autowrap = true
		_label.rect_min_size = min_size_label
