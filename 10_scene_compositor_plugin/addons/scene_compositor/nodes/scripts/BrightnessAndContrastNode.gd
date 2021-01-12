tool
extends BaseNode
class_name BrightnessAndContrastNode

var Definition = {
	"title": "Brightness/ContrastNode",
	"color": Global.DataTypeColor[Global.DataType.IMAGE],
	"label_min_size" : [140, 0],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.IMAGE,
			"var" : "o_image"
		}
	},
	"inputs" : {
		0: {
			"name" : "Image",
			"type" : Global.DataType.IMAGE,
			"editable" : false,
			"var" : "i_image"
		},
		1: {
			"name" : "Brightness",
			"type" : Global.DataType.SCALAR,
			"control" : "SliderControl",
			"editable" : true,
			"default" : 0.5,
			"var" : "i_brightness",
			"parameters": {
				"slider/max_value" : 1.0,
				"slider/min_value" : 0.0
			}
		},
		2: {
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
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition

func _execute():
	print("Executed Node %s" % title)
	var image = Image.new()
	_data["o_image"] = image

