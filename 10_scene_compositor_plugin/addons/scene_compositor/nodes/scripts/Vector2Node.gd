tool
extends BaseNode
class_name Vector2Node

var Definition = {
	"title": "Vector2Node",
	"color": Global.DataTypeColor[Global.DataType.VECTOR2],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.VECTOR2,
			"var" : "o_vector2"
		}
	},
	"extra" : {
		0: {
			"name" : "Data",
			"type" : Global.DataType.VECTOR2,
			"editable" : true,
			"label": false,
			"var" : "o_vector2"
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition

func _execute():
	print("Executed Node %s" % title)
