tool
extends BaseNode
class_name SubdivisionNode

var Definition = {
	"title": "SubdivisionNode",
	"color": Global.DataTypeColor[Global.DataType.GEOMETRY],
		"label_min_size" : [150, 0],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.GEOMETRY,
			"var" : "o_geometry"
		}
	},
	"extra" : {
		0: {
			"name" : "Method",
			"type" : Global.DataType.STRING,
			"control" : "DropdownControl",
			"editable" : true,
			"default" : "SIMPLE",
			"var" : "i_method",
			"parameters": {
				"options" : "SIMPLE,LOOP"
			}
		},
		1: {
			"name" : "Subdivisions",
			"type" : Global.DataType.SCALAR,
			"control" : "SpinControl",
			"editable" : true,
			"default" : 0,
			"var" : "i_subdivisions",
			"parameters": {
				"number/step" : 1,
				"number/max_value" : 10,
				"number/min_value" : 0
			}
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
	var subdivisions = _data["i_subdivisions"]
	var method = _data["i_method"]
	
	for i in range(subdivisions):
		match method :
			"LOOP":
				geometry = MeshSubdivision.loop(geometry)
			"SIMPLE":
				geometry = MeshSubdivision.simple(geometry)
	
	_data["o_geometry"] = geometry

