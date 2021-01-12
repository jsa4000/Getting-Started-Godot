extends Reference
class_name MeshSubdivision
	
const PI_2_FLOAT = PI / 2.0

static func simple(geometry : MeshInstance, smooth := false) -> MeshInstance:
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
			
			# 
			#          v1                     v1 
			#          /\                     /\ 
			#         /  \                   /  \  
			#        /    \      =>    mv0  /____\ mv1   
			#       /      \               / \  / \     
			#      / _______\             / __\/___\        
			#     v0       v2            v0   mv2    v2        
			
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
	
static func simple_merged(geometry : MeshInstance, smooth := false) -> MeshInstance:
	var cache = {}
	var mesh = ArrayMesh.new()
	var surfTool = SurfaceTool.new()
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surfTool.add_smooth_group(smooth)
	var mdt = MeshDataTool.new()
	
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)
			
		var vertices = {}
		for vertex_index in range(mdt.get_vertex_count()):
			var vertex = mdt.get_vertex(vertex_index)
			if not vertices.has(_generate_vertex_key(vertex)):
				surfTool.add_normal(mdt.get_vertex_normal(vertex_index))
				surfTool.add_uv(mdt.get_vertex_uv(vertex_index))
				surfTool.add_vertex(mdt.get_vertex(vertex_index))
				vertices[_generate_vertex_key(vertex)] = vertices.size()
			
		var v_count = mdt.get_vertex_count()
		for face_index in range(mdt.get_face_count()):
			
			var v0 = vertices[_generate_vertex_key(mdt.get_vertex(mdt.get_face_vertex(face_index, 0)))]
			var v1 = vertices[_generate_vertex_key(mdt.get_vertex(mdt.get_face_vertex(face_index, 1)))]
			var v2 = vertices[_generate_vertex_key(mdt.get_vertex(mdt.get_face_vertex(face_index, 2)))]
			
			var normal = mdt.get_face_normal(face_index)
			
			var key = _generate_edge_key(v0,v1)
			if not cache.has(key):
				surfTool.add_normal(normal)
				surfTool.add_uv(_get_middle_uv(mdt, v0, v1))
				surfTool.add_vertex(_get_middle_point(mdt, v0, v1))
				cache[key] = cache.size() + vertices.size()
			var mv0 = cache[key]
			
			key = _generate_edge_key(v1, v2)
			if not cache.has(key):
				surfTool.add_normal(normal)
				surfTool.add_uv(_get_middle_uv(mdt, v1, v2))
				surfTool.add_vertex(_get_middle_point(mdt, v1, v2))
				cache[key] = cache.size() + vertices.size()
			var mv1 = cache[key]
			
			key = _generate_edge_key(v2, v0)
			if not cache.has(key):
				surfTool.add_normal(normal)
				surfTool.add_uv(_get_middle_uv(mdt, v2, v0))
				surfTool.add_vertex(_get_middle_point(mdt, v2, v0))
				cache[key] = cache.size() + vertices.size()
			var mv2 = cache[key]
			
			_index_face(surfTool, v0, mv0, mv2)
			_index_face(surfTool, v1, mv1, mv0)
			_index_face(surfTool, v2, mv2, mv1)
			_index_face(surfTool, mv0, mv1, mv2)

		#surfTool.generate_normals()
		surfTool.commit(mesh)
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

static func loop(geometry : MeshInstance) -> MeshInstance:
	var mesh = ArrayMesh.new()
	var mdt = MeshDataTool.new()
	for si in range(geometry.mesh.get_surface_count()):
		mdt.create_from_surface(geometry.mesh, si)
		var surfTool = SurfaceTool.new()

		surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
		surfTool.add_smooth_group(true)

		# update even vertices
		for vi in range(mdt.get_vertex_count()):
			var oldv = mdt.get_vertex(vi)
			var edges = mdt.get_vertex_edges(vi)

			var n = edges.size()
			var beta = 3.0 / (8.0 * n) if n > 3 else 3.0/16.0

			var nvs = Vector3.ZERO
			for ei in edges:
				var nvi = _get_vertex_edge_neighbor(mdt, vi, ei)
				nvs += mdt.get_vertex(nvi)

			var newv = oldv * (1.0 - n * beta) + nvs * beta
			surfTool.add_vertex(newv)

		# add odd vertices
		var oddEdges = {}
		for ei in range(mdt.get_edge_count()):
			var ef = mdt.get_edge_faces(ei)

			var evi1 = mdt.get_edge_vertex(ei, 0)
			var evi2 = mdt.get_edge_vertex(ei, 1)

			var newEdgeVertex = 0
			var evs = mdt.get_vertex(evi1) + mdt.get_vertex(evi2)
			if (ef.size() > 1): # interior
				var efvi1 = mdt.get_face_vertex(ef[0], 0)
				var efvi2 = mdt.get_face_vertex(ef[1], 1)
				var avs = mdt.get_vertex(efvi1) + mdt.get_vertex(efvi2)
				newEdgeVertex = (3.0/8.0) * evs + (1.0/8.0) * avs
			elif ef.size() == 1: # boundary
				newEdgeVertex = evs / 2

			surfTool.add_vertex(newEdgeVertex)
			var newIndex = mdt.get_vertex_count() + ei
			oddEdges[ei] = newIndex

		# reconnect faces
		for fi in range(mdt.get_face_count()):
			var e1 = mdt.get_face_edge(fi, 0)
			var e2 = mdt.get_face_edge(fi, 1)
			var e3 = mdt.get_face_edge(fi, 2)

			var e1o = oddEdges[e1]
			var e2o = oddEdges[e2]
			var e3o = oddEdges[e3]

			var fe1 = mdt.get_face_vertex(fi, 0)
			var fe2 = mdt.get_face_vertex(fi, 1)
			var fe3 = mdt.get_face_vertex(fi, 2)

			_index_face(surfTool, e1o, e2o, e3o)
			_index_face(surfTool, e1o, fe2, e2o)
			_index_face(surfTool, e3o, e2o, fe3)
			_index_face(surfTool, fe1, e1o, e3o)

		surfTool.generate_normals()
		surfTool.commit(mesh)
	var result = MeshInstance.new()
	result.mesh = mesh
	return result

static func _get_middle_uv(mdt : MeshDataTool, vi1 : int, vi2 : int) -> Vector2:
	var uv1 = mdt.get_vertex_uv(vi1)
	var uv2 = mdt.get_vertex_uv(vi2)
	return (uv1 + uv2) * 0.5

static func _get_middle_point(mdt : MeshDataTool, vi1 : int, vi2 : int) -> Vector3:
	var v1 = mdt.get_vertex(vi1)
	var v2 = mdt.get_vertex(vi2)
	return (v1 + v2) * 0.5

static func _get_vertex_edge_neighbor(mdt, vi, ei):
	var evi1 = mdt.get_edge_vertex(ei, 0)
	var evi2 = mdt.get_edge_vertex(ei, 1)
	return evi1 if evi1 != vi else evi2

static func _index_face(surfaceTool, i1, i2, i3):
	surfaceTool.add_index(i1)
	surfaceTool.add_index(i2)
	surfaceTool.add_index(i3)

static func _generate_edge_key(v1 : int, v2: int) -> int:
	var smaller = min(v1, v2)
	var greater = max(v1, v2)
	return (smaller << 16) + greater
	
static func _generate_vertex_key(vertex : Vector3) -> String:
	return "%s" % vertex

