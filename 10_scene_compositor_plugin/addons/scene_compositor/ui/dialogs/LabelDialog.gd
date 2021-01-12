tool
extends Popup
class_name LabelDialog

const DefaultSize = Vector2(500, 30)

onready var label = $Label

signal closed(value)

func activate(name, size = DefaultSize, position = Vector2.INF):
	label.text = name
	popup_centered(size)
	if position != Vector2.INF:
		rect_position = position

func _on_LabelDialog_popup_hide():
		emit_signal("closed",label.text)
