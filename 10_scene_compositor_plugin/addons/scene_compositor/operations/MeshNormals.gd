extends Reference
class_name MeshNormals
	
static func smooth(geometry : MeshInstance, threshold_degrees := 0) -> MeshInstance:
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	var mdt2 = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)	
		mdt2.create_from_surface(geometry.mesh, si)	
		for vertex_index in range(mdt.get_vertex_count()):		
			var vertex_normal = Vector3.ZERO
			var neighbours = MeshUtils.get_nearest_neighbours(mdt2, vertex_index)
			for neighbour in neighbours:
				vertex_normal += mdt2.get_vertex_normal(neighbour)
			vertex_normal = vertex_normal / float(neighbours.size())
			mdt.set_vertex_normal(vertex_index, vertex_normal.normalized())
		mdt.commit_to_surface(mesh)
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

