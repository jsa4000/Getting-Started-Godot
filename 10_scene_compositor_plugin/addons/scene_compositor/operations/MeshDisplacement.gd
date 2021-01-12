extends Reference
class_name MeshDisplacement

static func displace(geometry: MeshInstance, texture : Texture, height := 0.0, fixed := true) -> MeshInstance:
	var image = texture.get_data()
	image.lock()	
	var vertices_slopes = {}
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)	
		for vertex_index in range(mdt.get_vertex_count()):		
			var vertex = mdt.get_vertex(vertex_index)
			if not vertices_slopes.has(_generate_key(vertex)):
				var uv = mdt.get_vertex_uv(vertex_index)
				var normal = mdt.get_vertex_normal(vertex_index)
				var color = get_color_from_uv(image, uv)
				vertices_slopes[_generate_key(vertex)] = normal * clamp(color.r * height,-1, 1)
			vertex += vertices_slopes[_generate_key(vertex)]
			mdt.set_vertex(vertex_index, vertex)
		mdt.commit_to_surface(mesh)
	image.unlock()
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

static func get_color_from_uv(image : Image, uv : Vector2) -> Color:
	var pixel = uv * (image.get_size() - Vector2.ONE)
	return image.get_pixelv(pixel)

static func _generate_key(vertex : Vector3) -> String:
	return "%s" % vertex
