tool
extends BaseNode
class_name SceneNode

var Definition = {
	"title": "SceneNode",
	"color": Color.red,
	"label_min_size" : [140, 0],
	"inputs" : {
		0: {
			"name" : "Camera",
			"type" : Global.DataType.CAMERA,
			"editable" : false,
			"var" : "i_camera"
		},
		1: {
			"name" : "Geometry",
			"type" : Global.DataType.GEOMETRY,
			"editable" : false,
			"var" : "i_geometry"
		},
		2: {
			"name" : "Animation",
			"type" : Global.DataType.UNKNOWN,
			"editable" : false,
			"var" : "i_animation"
		}
	}
}

func _get_definition() -> Dictionary:
	return Definition
	
func _execute():
	print("Executed Node %s" % title)

