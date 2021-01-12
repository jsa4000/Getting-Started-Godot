tool
extends BaseNode
class_name MaterialNode

var Definition = {
	"title": "MaterialNode",
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
			"name" : "Material",
			"type" : Global.DataType.MATERIAL,
			"control" : "OpenFileControl",
			"editable" : true,
			"var" : "i_material"
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition
	
func _validate():
	if _data["i_geometry"] == null:
		return false
	if _data["i_material"] == null || (_data["i_material"] is String && _data["i_material"].empty()):
		return false
	return true

func _execute():
	print("Executed Node %s" % title)
	var material = _data["i_material"]
	if material is String:
		material = load(_data["i_material"])
	
	var geometry = _data["i_geometry"]
	var output = MeshInstance.new()
	output.mesh = geometry.mesh
	output.material_override = material
	
	_data["o_geometry"] = output


