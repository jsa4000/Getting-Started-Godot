tool
extends BaseNode
class_name WireframeNode

var Definition = {
	"title": "WireframeNode",
	"color": Global.DataTypeColor[Global.DataType.GEOMETRY],
	"label_min_size" : [60, 0],
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
	
	var new_geometry = MeshUtils.wireframe(geometry)
	
	_data["o_geometry"] = new_geometry

