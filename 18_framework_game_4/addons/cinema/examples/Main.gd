extends Node3D

@onready var cameras_root : Node = $Cinema/Cameras
@onready var label_options : Label = $Controls/Options
@onready var label_selection : Label = $Controls/Selection

var cameras : Array = []

func _ready():
	_init_cameras()
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and (event.keycode >= KEY_1 and event.keycode <= KEY_9):
			_select_camera(event.keycode - KEY_1)

func _select_camera(index : int) -> void:
	label_selection.text = "Camera %s has been selected" % cameras[index].id
	cameras[index].enabled = true

func _init_cameras():
	var options = PackedStringArray()
	options.append("Select the current camera:")
	for index in range(cameras_root.get_child_count()):
		var camera = cameras_root.get_child(index)
		options.append("%d - %s" % [index + 1,camera.id])
		cameras.append(camera)
#		if index > 8:
#			break
	label_options.text = "\n".join(options)

