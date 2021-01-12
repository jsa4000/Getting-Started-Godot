tool
extends BaseNode
class_name BoolNode

var Definition = {
	"title": "BoolNode",
	"color": Global.DataTypeColor[Global.DataType.BOOL],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.BOOL,
			"var" : "o_bool"
		}
	},
	"extra" : {
		0: {
			"name" : "Data",
			"type" : Global.DataType.BOOL,
			"editable" : true,
			"label": false,
			"var" : "o_bool"
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition
	
func _execute():
	print("Executed Node %s" % title)
