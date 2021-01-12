tool
extends BaseNode
class_name DisplacementNode

var Definition = {
	"title": "DisplacementNode",
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
			"name" : "Image",
			"type" : Global.DataType.IMAGE,
			"control" : "OpenFileControl",
			"editable" : true,
			"var" : "i_image"
		},
		2: {
			"name" : "Height",
			"type" : Global.DataType.SCALAR,
			"control" : "SpinControl",
			"editable" : true,
			"default" : 0.0,
			"var" : "i_height",
			"parameters": {
				"number/step" : 0.01,
				"number/max_value" : 2,
				"number/min_value" : 0
			}
		}
	},
}

func _get_definition() -> Dictionary:
	return Definition
	
func _validate():
	if _data["i_geometry"] == null:
		return false
	if _data["i_image"] == null || (_data["i_image"] is String && _data["i_image"].empty()):
		return false
	return true

func _execute():
	print("Executed Node %s" % title)
	var image = _data["i_image"]
	if image is String:
		image = Image.new()
		image.load(_data["i_image"])
	image.save_png("res://temp/DisplacementNode.png")
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	var height = _data["i_height"]
	var geometry = _data["i_geometry"]
	var output = MeshDisplacement.displace(geometry, texture, height)
	
	_data["o_geometry"] = output


