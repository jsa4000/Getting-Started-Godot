tool
extends BaseNode
class_name ImageToGeometryNode

var Definition = {
	"title": "ImageToGeometryNode",
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
			"name" : "Image",
			"type" : Global.DataType.IMAGE,
			"control" : "OpenFileControl",
			"editable" : true,
			"var" : "i_image"
		},
		1: {
			"name" : "Position",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_position"
		},
		2: {
			"name" : "Rotation",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_rotation"
		},
		3: {
			"name" : "Scale",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"default" : "Vector3(1.0,1.0,1.0)",
			"var" : "i_scale"
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
	image.save_png("res://temp/ImageToGeometryNode.png")
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	var sprite3d = Sprite3D.new()
	sprite3d.texture = texture
	
	sprite3d.global_transform.origin = _data["i_position"]
	sprite3d.rotation = _data["i_rotation"]
	sprite3d.scale = _data["i_scale"]
	
	_data["o_geometry"] = sprite3d


