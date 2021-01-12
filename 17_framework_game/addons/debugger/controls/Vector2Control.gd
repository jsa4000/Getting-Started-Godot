tool
extends BaseControl
class_name Vector2Control

export (Vector2) var value: Vector2 = Vector2(0,0) setget set_value, get_value

onready var _scalar_x : BaseControl = $Layout/ScalarX
onready var _scalar_y : BaseControl = $Layout/ScalarY

func _ready():
	set_value(value)

func get_value() -> Vector2:  
	return value

func set_value(val : Vector2): 
	value = val
	if _scalar_x != null:
		_scalar_x.set_value(value.x)
	if _scalar_y != null:
		_scalar_y.set_value(value.y)
	emit_signal("value_changed", self, value)

func _on_ScalarX_value_changed(control, val):
	value = Vector2(val, value.y)
	emit_signal("value_changed", self, get_value())

func _on_ScalarY_value_changed(control, val):
	value = Vector2(value.x, val)
	emit_signal("value_changed", self, get_value())
