tool
extends BaseNode
class_name CameraNode

var Definition = {
	"title": "CameraNode",
	"color": Global.DataTypeColor[Global.DataType.CAMERA],
	"label_min_size" : [140, 0],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.CAMERA,
			"var" : "o_camera"
		}
	},
	"inputs" : {
		0: {
			"name" : "Position",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_position"
		},
		1: {
			"name" : "Rotation",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_rotation"
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition

func _execute():
	print("Executed Node %s" % title)
	var camera = Camera.new()
	_data["o_camera"] = camera
