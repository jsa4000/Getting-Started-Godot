extends Reference
class_name MeshUtils
	
enum VertexDataType { POINT, NORMAL, COLOR, TANGENT, UV, UV2, WEIGHTS, BONES}	

const VertexDataName = {
	VertexDataType.POINT : "P", 
	VertexDataType.NORMAL : "N", 
	VertexDataType.COLOR : "Cd", 
	VertexDataType.TANGENT : "T", 
	VertexDataType.UV : "UV", 
	VertexDataType.UV2 : "UV2", 
	VertexDataType.WEIGHTS : "Ws", 
	VertexDataType.BONES : "Bs", 
}
	
static func wireframe(geometry : MeshInstance) -> MeshInstance:	
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)
		var material = geometry.mesh.surface_get_material(si)	
		var vertices = PoolVector3Array()		
		for face_index in range(mdt.get_face_count()):		
			var v0 = mdt.get_face_vertex(face_index, 0)
			var v1 = mdt.get_face_vertex(face_index, 1)
			var v2 = mdt.get_face_vertex(face_index, 2)
			
			vertices.push_back(mdt.get_vertex(v0))
			vertices.push_back(mdt.get_vertex(v1))
			
			vertices.push_back(mdt.get_vertex(v1))
			vertices.push_back(mdt.get_vertex(v2))
			
			vertices.push_back(mdt.get_vertex(v2))
			vertices.push_back(mdt.get_vertex(v0))
			
		var arrays = []
		arrays.resize(ArrayMesh.ARRAY_MAX)
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
		mesh.surface_set_material(si, material)	
	var result = MeshInstance.new()
	result.mesh = mesh
	return result
	
static func transform(geometry : MeshInstance, position, rotation_degrees, scale) -> MeshInstance:
	var dummy = MeshInstance.new()
	dummy.global_transform.origin = position
	dummy.rotation = rotation_degrees
	dummy.scale = scale
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)	
		for vertex_index in range(mdt.get_vertex_count()):		
			var vertex = mdt.get_vertex(vertex_index)
			vertex = dummy.transform * vertex
			mdt.set_vertex(vertex_index, vertex)
		mdt.commit_to_surface(mesh)
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

static func get_vertex_info(geometry : MeshInstance, fields : Array = [VertexDataType.POINT]) -> Array:
	var info = []
	var mdt = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)	
		for vertex_index in range(mdt.get_vertex_count()):		
			var vertex_info = {}
			for item in fields:
				match item:
					VertexDataType.POINT:
						vertex_info[VertexDataName[item]] = mdt.get_vertex(vertex_index)
					VertexDataType.NORMAL:
						vertex_info[VertexDataName[item]] = mdt.get_vertex_normal(vertex_index)
					VertexDataType.COLOR:
						vertex_info[VertexDataName[item]] = mdt.get_vertex_color(vertex_index)
					VertexDataType.TANGENT: 
						vertex_info[VertexDataName[item]] = mdt.get_vertex(vertex_index)
					VertexDataType.UV:
						vertex_info[VertexDataName[item]] = mdt.get_vertex_uv(vertex_index)
					VertexDataType.UV2:
						vertex_info[VertexDataName[item]] = mdt.get_vertex_uv2(vertex_index)
					VertexDataType.WEIGHTS:
						vertex_info[VertexDataName[item]] = mdt.get_vertex_weights(vertex_index)
					VertexDataType.BONES:
						vertex_info[VertexDataName[item]] = mdt.get_vertex_bones(vertex_index)
					_:
						vertex_info[item] = mdt.get_vertex_meta(vertex_index)[item]
			info.append(vertex_info)
	return info

static func face_normal_lines(geometry : MeshInstance, length := 0.5, color := Color.orange) -> MeshInstance:	
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)
		var vertices = PoolVector3Array()			
		for face_index in range(mdt.get_face_count()):
			var v0 = mdt.get_vertex(mdt.get_face_vertex(face_index, 0))
			var v1 = mdt.get_vertex(mdt.get_face_vertex(face_index, 1))
			var v2 = mdt.get_vertex(mdt.get_face_vertex(face_index, 2))
			var normal = mdt.get_face_normal(face_index)
			var center  = (v0 + v1 + v2) / 3.0
			var end = (center + (normal * length))
			vertices.push_back(center)
			vertices.push_back(end)
		var arrays = []
		arrays.resize(ArrayMesh.ARRAY_MAX)
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	var result = MeshInstance.new()
	result.mesh = mesh
	result.material_override = generate_line_material(color)
	return result

static func vertex_normal_lines(geometry : MeshInstance, length := 0.3, color := Color.white) -> MeshInstance:	
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)
		var vertices = PoolVector3Array()	
		var colors = PoolColorArray()			
		for vertex_index in range(mdt.get_vertex_count()):
			var vertex = mdt.get_vertex(vertex_index)
			var normal = mdt.get_vertex_normal(vertex_index)
			var end = (vertex + (normal * length))
			vertices.push_back(vertex)
			vertices.push_back(end)
		var arrays = []
		arrays.resize(ArrayMesh.ARRAY_MAX)
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	var result = MeshInstance.new()
	result.mesh = mesh
	result.material_override = generate_line_material(color)
	return result

static func generate_line_material(color := Color.white, transparency := 0.5) -> Material:
	var material : Material = SpatialMaterial.new()
	material.albedo_color = color
	material.albedo_color.a = transparency
	material.flags_transparent = true
	material.flags_unshaded = true
	return material

static func get_nearest_neighbours(mdt : MeshDataTool, vertex_index : int, distance := 0.0) -> PoolIntArray:
	var neighbours = PoolIntArray()
	var nearest_points = get_nearest_points(mdt,vertex_index)
	for p in nearest_points:
		var edges = mdt.get_vertex_edges(p)
		for edge_index in edges:
			for i in range(2):
				var ev = mdt.get_edge_vertex(edge_index,i) 
				if ev != p:
					neighbours.append(ev)
	return neighbours

static func get_nearest_points(mdt : MeshDataTool, vertex_index : int, threshold := 0.0, exclude_source := false) -> PoolIntArray:
	var result = PoolIntArray()
	var source = mdt.get_vertex(vertex_index)
	for i in range(mdt.get_vertex_count()):
		if i == vertex_index && exclude_source:
			continue
		var vector = source - mdt.get_vertex(i)
		if abs(vector.length()) <= threshold:
			result.append(i)
	return result
