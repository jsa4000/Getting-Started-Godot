tool
extends BaseNode
class_name ImageRectToPosition3DNode

var Definition = {
	"title": "ImageRectToPosition3DNode.gd",
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
			"editable" : false,
			"var" : "i_image"
		},
		1: {
			"name" : "Geometry",
			"type" : Global.DataType.GEOMETRY,
			"editable" : false,
			"var" : "i_geometry"
		}
	}
}

func _get_definition() -> Dictionary:
	return Definition
	
func _validate():
	if _data["i_image"] == null:
		return false
	if _data["i_geometry"] == null:
		return false
	return true

func _execute():
	print("Executed Node %s" % title)
	
	var mesh = _data["i_geometry"]
	var image = _data["i_image"]
	
	var image_used_rect = image.get_used_rect() #  ( float x, float y, float width, float height )
	var image_size = image.	get_size() #  (width and height).
	print(image_used_rect) # (422, 375, 714, 1323)
	print(image_size) # (3400, 5000)
	
	
	# MeshDataTool - 	Vector2 	get_vertex_uv ( int idx ) const



	
	var position3d = Position3D.new()
	
	var dummy = MeshInstance.new()
	dummy.mesh = SphereMesh.new()
	dummy.scale = Vector3(0.1,0.1,0.1)
	position3d.add_child(dummy)
	
	_data["o_geometry"] = position3d

