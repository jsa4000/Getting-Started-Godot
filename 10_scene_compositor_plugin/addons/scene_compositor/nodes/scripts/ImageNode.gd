tool
extends BaseNode
class_name ImageNode

var Definition = {
	"title": "ImageNode",
	"color": Global.DataTypeColor[Global.DataType.IMAGE],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.IMAGE,
			"var" : "o_image"
		}
	},
	"extra" : {
		0: {
			"name" : "Data",
			"type" : Global.DataType.FILE,
			"editable" : true,
			"label": false,
			"var" : "i_image"
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition

func _validate():
	if _data["i_image"] == null:
		return false
	return true

func _execute():
	print("Executed Node %s" % title)
	var image = _data["i_image"]
	if image is String:
		image = Image.new()
		image.load(_data["i_image"])
	_data["o_image"] = image
	image.save_png("res://temp/ImageNode.png")
	


