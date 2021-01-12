tool
extends BaseNode
class_name TransformNode

var Definition = {
	"title": "TransformNode",
	"color": Global.DataTypeColor[Global.DataType.GEOMETRY],
	"label_min_size" : [140, 0],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.GEOMETRY,
			"var" : "o_geometry"
		}
	},
	"inputs" : {
		0: {
			"name" : "Geometry",
			"type" : Global.DataType.GEOMETRY,
			"var" : "i_geometry"
		},
		1: {
			"name" : "Position",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_position"
		},
		2: {
			"name" : "Rotation",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_rotation"
		},
		3: {
			"name" : "Scale",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"default" : "Vector3(1.0,1.0,1.0)",
			"var" : "i_scale"
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition
	
func _validate():
	if _data["i_geometry"] == null:
		return false
	return true

func _execute():
	print("Executed Node %s" % title)
	
	var geometry = _data["i_geometry"]
	
	var position = _data["i_position"]
	var rotation = _data["i_rotation"]
	var scale = _data["i_scale"]
	
	geometry = MeshUtils.transform(geometry, position, rotation, scale)
	
	_data["o_geometry"] = geometry

