tool
extends BaseNode
class_name Vector3Node

var Definition = {
	"title": "Vector3Node",
	"color": Global.DataTypeColor[Global.DataType.VECTOR3],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.VECTOR3,
			"var" : "o_vector3"
		}
	},
	"extra" : {
		0: {
			"name" : "Data",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"label": false,
			"var" : "o_vector3",
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition

func _execute():
	print("Executed Node %s" % title)

