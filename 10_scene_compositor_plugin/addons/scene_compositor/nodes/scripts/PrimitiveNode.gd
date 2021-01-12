tool
extends BaseNode
class_name PrimitiveMeshNode

var Definition = {
	"title": "PrimitiveMeshNode",
	"color": Global.DataTypeColor[Global.DataType.GEOMETRY],
	"label_min_size" : [140, 0],
	"outputs" : {
		0: {
			"name" : "Output",
			"type" : Global.DataType.GEOMETRY,
			"var" : "o_geometry"
		}
	},
	"extra" : {
		0: {
			"name" : "Geometry",
			"type" : Global.DataType.STRING,
			"control" : "DropdownControl",
			"editable" : true,
			"default" : "CUBE",
			"var" : "i_type",
			"parameters": {
				"options" : "CUBE,SPHERE,PLANE,CYLINDER,CAPSULE"
			}
		}
	},
	"inputs" : {
		0: {
			"name" : "Position",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_position"
		},
		1: {
			"name" : "Rotation",
			"type" : Global.DataType.VECTOR3,
			"editable" : true,
			"var" : "i_rotation"
		},
		2: {
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
	return true

func _execute():
	print("Executed Node %s" % title)
	
	var mesh
	match _data["i_type"] :
		"CUBE":
			mesh = CubeMesh.new()
		"SPHERE":
			mesh = SphereMesh.new()
		"PLANE":
			mesh = PlaneMesh.new()
		"CYLINDER":
			mesh = CylinderMesh.new()
		"CAPSULE":
			mesh = CapsuleMesh.new()
		_:
			mesh = CubeMesh.new()
	
	var geometry = MeshInstance.new()
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.get_mesh_arrays())
	geometry.mesh = array_mesh
			
	var position = _data["i_position"]
	var rotation = _data["i_rotation"]
	var scale = _data["i_scale"]
	
	geometry = MeshUtils.transform(geometry, position, rotation, scale)
	
	_data["o_geometry"] = geometry


