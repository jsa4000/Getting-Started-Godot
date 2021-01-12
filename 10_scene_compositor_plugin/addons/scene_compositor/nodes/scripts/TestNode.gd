tool
extends BaseNode
class_name TestNode

var Definition = {
	"title": "TestNode",
	"color": Color.aquamarine,
	"label_min_size" : [140, 0],
	"inputs" : {
		0: {
			"name" : "Image",
			"type" : Global.DataType.IMAGE,
			"optional" : false,
			"var" : "i_image"
		},
		1: {
			"name" : "Texture",
			"type" : Global.DataType.IMAGE,
			"color" : Global.DataTypeColor[Global.DataType.IMAGE],
			"control" : "OpenFileControl",
			"editable" : true,
			"var" : "i_texture"
		},
		2: {
			"name" : "Offset",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"default" : "Vector3(1.0,1.0,1.0)",
			"var" : "i_offset",
		},
		3: {
			"name" : "Smooth",
			"type" : Global.DataType.BOOL,
			"editable" : true,
			"default" : true,
			"var" : "i_transparency"
		}
	},
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.IMAGE,
			"var" : "o_transparency"
		},
		1: {
			"name" : "Alpha",
			"type" : Global.DataType.SCALAR,
			"var" : "o_alpha"
		},
		2: {
			"name" : "Other",
			"type" : Global.DataType.UNKNOWN,
			"var" : "o_other"
		}
	},
	"extra" : {
		0: {
			"name" : "Contrast",
			"type" : Global.DataType.SCALAR,
			"control" : "SliderControl",
			"editable" : true,
			"default" : 0.5,
			"var" : "i_contrast",
			"parameters": {
				"slider/max_value" : 1.0,
				"slider/min_value" : 0.0
			}
		},
		1: {
			"name" : "Brightness",
			"type" : Global.DataType.SCALAR,
			"control" : "SliderControl",
			"editable" : true,
			"var" : "i_brightness"
		},
		2: {
			"name" : "Type",
			"type" : Global.DataType.STRING,
			"control" : "DropdownControl",
			"editable" : true,
			"default" : "THIRD",
			"var" : "i_type",
			"parameters": {
				"options" : "FIRST,SECOND,THIRD,FOURTH"
			}
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition

func _execute():
	print("Executed Node %s" % title)

