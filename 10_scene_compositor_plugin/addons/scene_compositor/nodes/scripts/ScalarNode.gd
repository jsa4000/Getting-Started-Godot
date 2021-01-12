tool
extends BaseNode
class_name ScalarNode

var Definition = {
	"title": "ScalarNode",
	"color": Global.DataTypeColor[Global.DataType.SCALAR],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.SCALAR,
			"var" : "o_scalar"
		}
	},
	"extra" : {
		0: {
			"name" : "Data",
			"type" : Global.DataType.SCALAR,
			"editable" : true,
			"label": false,
			"var" : "o_scalar"
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition

func _execute():
	print("Executed Node %s" % title)
	
