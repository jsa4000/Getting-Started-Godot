class_name GrassFactory extends Object

static func create():
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	
	verts.append(Vector3(-0.5, 0.0, 0.0))
	uvs.append(Vector2(0.0, 0.0))
	
	verts.append(Vector3(0.5, 0.0, 0.0))
	uvs.append(Vector2(0.0, 0.0))
	
	verts.append(Vector3(0.0, 1.0, 0.0))
	uvs.append(Vector2(1.0, 1.0))
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV2] = uvs
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh.custom_aabb = AABB(Vector3(-0.5, 0.0, -0.5), Vector3(1.0, 1.0, 1.0))
	
	return mesh
