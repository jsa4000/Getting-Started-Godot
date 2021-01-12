tool
extends Camera
class_name CameraTrackTo

export(NodePath) var position3D
export(Vector3) var up = Vector3.UP

onready var _position3D : Position3D = get_node(position3D)

func _get_configuration_warning():
	var errors = PoolStringArray()
	if is_inside_tree() && not position3D:
		errors.append("Position3D has not been defined")
	return errors.join("\n")	

func _process(delta):
	if is_inside_tree() && _position3D:
		look_at(_position3D.translation, up)
