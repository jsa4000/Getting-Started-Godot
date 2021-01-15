extends Control

@export_enum("Intro", "Advanced", "Other", "None") var labels : String
var _label : String = "Intro"
var label : String:
	set(value):
		_set_label(value)
	get: return _label

@onready var _label_ctrls : Array = [$Intro, $Advanced, $Other]

func _ready():
	_set_label(_label)

func _set_label(value : String) -> void:
	if value == _label:
		return
	_label = value
	_set_lable_ctrl(_label)

func _set_lable_ctrl(label_name : String) -> void:
	for ctrl in _label_ctrls:
		ctrl.visible = false
	if label_name == "Intro":
		_label_ctrls[0].visible = true
	elif  label_name == "Advanced":
		_label_ctrls[1].visible = true
	elif  label_name == "Other":
		_label_ctrls[2].visible = true
