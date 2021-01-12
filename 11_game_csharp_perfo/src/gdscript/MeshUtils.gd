extends Reference
class_name MeshUtils

static func subdivide(geometry : MeshInstance, smooth := false) -> MeshInstance:
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()	
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)
			
		var totalVertices = (mdt.get_face_count() * 3) * 2; # Each triable doubles the number of vertices. A triangle has 3 vertices.
		var totalIndices = (mdt.get_face_count() * 4) * 3;  # Each triangle is divided by 4, 3 indices each one.

		var vertices = PoolVector3Array()
		var uvs = PoolVector2Array()
		var normals =  PoolVector3Array()
		var indices = PoolIntArray()
		
		for face_index in range(mdt.get_face_count()):
			var vertex_count = face_index * 6
			var vertex_indices = face_index * 12
			var face_normal = mdt.get_face_normal(face_index)

			var v0 = mdt.get_face_vertex(face_index, 0)
			var v1 = mdt.get_face_vertex(face_index, 1)
			var v2 = mdt.get_face_vertex(face_index, 2)

			uvs.append(mdt.get_vertex_uv(v0))
			normals.append(mdt.get_vertex_normal(v0))
			vertices.append(mdt.get_vertex(v0))

			uvs.append(mdt.get_vertex_uv(v1))
			normals.append(mdt.get_vertex_normal(v1))
			vertices.append(mdt.get_vertex(v1))

			uvs.append(mdt.get_vertex_uv(v2))
			normals.append(mdt.get_vertex_normal(v2))
			vertices.append(mdt.get_vertex(v2))

			var mv0 = vertex_count + 3;
			var mv1 = vertex_count + 4;
			var mv2 = vertex_count + 5;

			uvs.append(_get_middle_uv(mdt, v0, v1))
			normals.append(_get_middle_normal(mdt, v0, v1))
			vertices.append(_get_middle_point(mdt, v0, v1))

			uvs.append(_get_middle_uv(mdt, v1, v2))
			normals.append(_get_middle_normal(mdt, v1, v2))
			vertices.append(_get_middle_point(mdt, v1, v2))

			uvs.append(_get_middle_uv(mdt, v2, v0))
			normals.append(_get_middle_normal(mdt, v2, v0))
			vertices.append(_get_middle_point(mdt, v2, v0))

			indices.append(vertex_count)
			indices.append(mv0)
			indices.append(mv2)
			indices.append(vertex_count + 1)
			indices.append(mv1) 
			indices.append(mv0)
			indices.append(vertex_count + 2)
			indices.append(mv2) 
			indices.append(mv1)
			indices.append(mv0) 
			indices.append(mv1) 
			indices.append(mv2)

		# Arrays must be here since vertices, uvs, pointers can change...
		var arrays = []
		arrays.resize(Mesh.ARRAY_MAX);
		
		arrays[Mesh.ARRAY_VERTEX] = vertices
		arrays[Mesh.ARRAY_TEX_UV] = uvs
		arrays[Mesh.ARRAY_NORMAL] = normals
		arrays[Mesh.ARRAY_INDEX] = indices

		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

static func subdivide2(geometry : MeshInstance, smooth := false) -> MeshInstance:
	var mesh = ArrayMesh.new()
	var surfTool = SurfaceTool.new()
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surfTool.add_smooth_group(smooth)
	var mdt = MeshDataTool.new()
	
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)
			
		for vertex_index in range(mdt.get_vertex_count()):
			surfTool.add_uv(mdt.get_vertex_uv(vertex_index))
			surfTool.add_vertex(mdt.get_vertex(vertex_index))
			
		var v_count = mdt.get_vertex_count()
		for face_index in range(mdt.get_face_count()):
			
			var v0 = mdt.get_face_vertex(face_index, 0)
			var v1 = mdt.get_face_vertex(face_index, 1)
			var v2 = mdt.get_face_vertex(face_index, 2)     
			
			surfTool.add_uv(_get_middle_uv(mdt, v0, v1))
			surfTool.add_vertex(_get_middle_point(mdt, v0, v1))
			
			surfTool.add_uv(_get_middle_uv(mdt, v1, v2))
			surfTool.add_vertex(_get_middle_point(mdt, v1, v2))
			
			surfTool.add_uv(_get_middle_uv(mdt, v2, v0))
			surfTool.add_vertex(_get_middle_point(mdt, v2, v0))
			
			var mv0 = v_count
			var mv1 = v_count + 1
			var mv2 = v_count + 2 
			
			_index_face(surfTool, v0, mv0, mv2)
			_index_face(surfTool, v1, mv1, mv0)
			_index_face(surfTool, v2, mv2, mv1)
			_index_face(surfTool, mv0, mv1, mv2)
			
			v_count += 3
			
		surfTool.generate_normals()
		surfTool.commit(mesh)
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

static func smooth(geometry : MeshInstance, threshold_degrees := 0) -> MeshInstance:
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	var mdt2 = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)	
		mdt2.create_from_surface(geometry.mesh, si)	
		for vertex_index in range(mdt.get_vertex_count()):		
			var vertex_normal = Vector3.ZERO
			var neighbours = get_nearest_neighbours(mdt2, vertex_index)
			for neighbour in neighbours:
				vertex_normal += mdt2.get_vertex_normal(neighbour)
			vertex_normal = vertex_normal / float(neighbours.size())
			mdt.set_vertex_normal(vertex_index, vertex_normal.normalized())
		mdt.commit_to_surface(mesh)
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

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

static func _get_middle_uv(mdt : MeshDataTool, vi1 : int, vi2 : int) -> Vector2:
	var uv1 = mdt.get_vertex_uv(vi1)
	var uv2 = mdt.get_vertex_uv(vi2)
	return (uv1 + uv2) * 0.5
	
static func _get_middle_normal(mdt : MeshDataTool, vi1 : int, vi2 : int) -> Vector2:
	var nv1 = mdt.get_vertex_normal(vi1)
	var nv2 = mdt.get_vertex_normal(vi2)
	return ((nv1 + nv2) * 0.5).normalized()

static func _get_middle_point(mdt : MeshDataTool, vi1 : int, vi2 : int) -> Vector3:
	var v1 = mdt.get_vertex(vi1)
	var v2 = mdt.get_vertex(vi2)
	return (v1 + v2) * 0.5

static func _index_face(surfaceTool, i1, i2, i3):
	surfaceTool.add_index(i1)
	surfaceTool.add_index(i2)
	surfaceTool.add_index(i3)

static func create_quad() -> MeshInstance:

	var vertices = PoolVector3Array()
	vertices.append(Vector3(0, 0, 0))
	vertices.append(Vector3(16, 0, 0))
	vertices.append(Vector3(16, 0, 16))
	vertices.append(Vector3(0, 0, 16))
	
	var colors = PoolColorArray()
	colors.append(Color(1, 1, 1, 1))
	colors.append(Color(1, 1, 1, 1))
	colors.append(Color(1, 1, 1, 1))
	colors.append(Color(1, 1, 1, 1))

	var uvs = PoolVector2Array()
	uvs.append(Vector2(0, 0))
	uvs.append(Vector2(1, 0))
	uvs.append(Vector2(1, 1))
	uvs.append(Vector2(0, 1))

	var indices = PoolIntArray([0,2,3, 0,1,2])
	
	var array_mesh = ArrayMesh.new()
	var arrays = []

	arrays.resize(Mesh.ARRAY_MAX);
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices

	var result = MeshInstance.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	result.mesh = array_mesh
	print("Surface has been created")
	return result


static func create_sphere() -> MeshInstance:

	var arr = []
	arr.resize(Mesh.ARRAY_MAX)

	# PoolVectorXXArrays for mesh construction.
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	var indices = PoolIntArray()
	
	var rings = 50
	var radial_segments = 50
	var height = 1
	var radius = 1
	
	# Vertex indices.
	var thisrow = 0
	var prevrow = 0
	var point = 0

	# Loop over rings.
	for i in range(rings + 1):
		var v = float(i) / rings
		var w = sin(PI * v)
		var y = cos(PI * v)
		# Loop over segments in ring.
		for j in range(radial_segments):
			var u = float(j) / radial_segments
			var x = sin(u * PI * 2.0)
			var z = cos(u * PI * 2.0)
			var vert = Vector3(x * radius * w, y, z * radius * w)
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(u, v))
			point += 1

			# Create triangles in ring using indices.
			if i > 0 and j > 0:
				indices.append(prevrow + j - 1)
				indices.append(prevrow + j)
				indices.append(thisrow + j - 1)

				indices.append(prevrow + j)
				indices.append(thisrow + j)
				indices.append(thisrow + j - 1)

		if i > 0:
			indices.append(prevrow + radial_segments - 1)
			indices.append(prevrow)
			indices.append(thisrow + radial_segments - 1)

			indices.append(prevrow)
			indices.append(prevrow + radial_segments)
			indices.append(thisrow + radial_segments - 1)

		prevrow = thisrow
		thisrow = point
	
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)

	var result = MeshInstance.new()
	result.mesh = mesh
	print("Surface has been created")
	return result
