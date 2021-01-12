tool
extends Spatial

const VertexDataTypes = [MeshUtils.VertexDataType.POINT, MeshUtils.VertexDataType.NORMAL, MeshUtils.VertexDataType.UV]

enum PrimitiveType {CUBE, SPHERE, PLANE, CYLINDER, CAPSULE, IMPORT }
enum SubdivisionType {LOOP, SIMPLE, SIMPLE_MERGED}

export(PrimitiveType) var primitive_type = PrimitiveType.CUBE setget set_primitive_type
export(PackedScene) var imported_mesh setget set_imported_mesh
export(SubdivisionType) var subdivision_type = SubdivisionType.LOOP setget set_subdivision_type
export(int) var subdivisions = 0 setget set_subdivisions
export(bool) var subdivision_smooth = false setget set_subdivision_smooth
export(bool) var compute_smooth = false setget set_compute_smooth
export(bool) var wireframe = false setget set_wireframe

export(Material) var material = null setget set_material

export(Vector3) var local_position = Vector3.ZERO setget set_local_position
export(Vector3) var local_rotation_degrees = Vector3.ZERO setget set_local_rotation_degrees
export(Vector3) var local_scale = Vector3.ONE setget set_local_scale

export(bool) var displacement_enabled = false setget set_displacement_enabled
export(Texture) var displacement_texture = null setget set_displacement_texture
export(float, -1 ,1) var displacement_height = 0 setget set_displacement_height

export(bool) var show_face_normals = false setget set_show_face_normals
export(bool) var show_vertex_normals = false setget set_show_vertex_normals

var geometry : MeshInstance = null
var face_normals : MeshInstance = null
var vertex_normals : MeshInstance = null

func set_primitive_type(value):
	primitive_type = value
	_generate()

func set_imported_mesh(value):
	imported_mesh = value
	_generate()

func set_subdivision_type(value):
	subdivision_type = value
	_generate()
	
func set_subdivisions(value):
	subdivisions = value
	_generate()

func set_subdivision_smooth(value):
	subdivision_smooth = value
	_generate()

func set_compute_smooth(value):
	compute_smooth = value
	_generate()

func set_wireframe(value):
	wireframe = value
	_generate()
	
func set_material(value):
	material = value
	_generate()
	
func set_local_position(value):
	local_position = value
	_generate()
	
func set_local_rotation_degrees(value):
	local_rotation_degrees = value
	_generate()
	
func set_local_scale(value):
	local_scale = value
	_generate()

func set_displacement_enabled(value):
	displacement_enabled = value
	_generate()
		
func set_displacement_texture(value):
	displacement_texture = value
	_generate()
	
func set_displacement_height(value):
	displacement_height = value
	_generate()

func set_show_face_normals(value):
	show_face_normals = value
	_generate()
	
func set_show_vertex_normals(value):
	show_vertex_normals = value
	_generate()

func _ready():
	_generate()

func _generate():
	if not is_inside_tree():
		return
	_remove_geometry(geometry)
	geometry = _get_primitive(primitive_type)
	geometry = MeshUtils.transform(geometry, local_position, local_rotation_degrees, local_scale)
	#print(MeshUtils.get_vertex_info(geometry, VertexDataTypes))
	var old_geometry = geometry
	for i in range(subdivisions):
		geometry = _subdivide(geometry, subdivision_type)
	if compute_smooth:
		geometry = MeshNormals.smooth(geometry)
	#print(MeshUtils.get_vertex_info(geometry, VertexDataTypes))
	if displacement_enabled:
		geometry = MeshDisplacement.displace(geometry, displacement_texture, displacement_height)
	#print(MeshUtils.get_vertex_info(geometry, VertexDataTypes).size())
	_show_face_normals()
	_show_vertex_normals()
	
	if wireframe:
		geometry = MeshUtils.wireframe(geometry)
	if material != null:
		geometry.material_override = material
	add_child(geometry)

func _show_face_normals():
	if face_normals != null:
		remove_child(face_normals)
		face_normals.queue_free()
	
	if show_face_normals:
		face_normals = MeshUtils.face_normal_lines(geometry)
		add_child(face_normals)
		
func _show_vertex_normals():
	if vertex_normals != null:
		remove_child(vertex_normals)
		vertex_normals.queue_free()
		
	if show_vertex_normals:
		vertex_normals = MeshUtils.vertex_normal_lines(geometry)
		add_child(vertex_normals)
	
func _remove_geometry(geometry : MeshInstance):
	if not geometry:
		return
	remove_child(geometry)
	geometry.queue_free()

func _get_primitive(primitive_type : int =  -1) -> MeshInstance:
	var mesh : Mesh
	if primitive_type == PrimitiveType.IMPORT:
		return imported_mesh.instance()
	else:
		match primitive_type :
			PrimitiveType.CUBE:
				mesh = CubeMesh.new()
			PrimitiveType.SPHERE:
				mesh = SphereMesh.new()
			PrimitiveType.PLANE:
				mesh = PlaneMesh.new()
			PrimitiveType.CYLINDER:
				mesh = CylinderMesh.new()
			PrimitiveType.CAPSULE:
				mesh = CapsuleMesh.new()
			_:
				mesh = CubeMesh.new()
		var geometry = MeshInstance.new()
		var array_mesh := ArrayMesh.new()
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.get_mesh_arrays())
		geometry.mesh = array_mesh
		return geometry
	
func _subdivide(geometry : MeshInstance, subdivision_type : int = -1) -> MeshInstance:
	match subdivision_type :
		SubdivisionType.LOOP:
			return MeshSubdivision.loop(geometry)
		SubdivisionType.SIMPLE:
			return MeshSubdivision.simple(geometry,subdivision_smooth)
		SubdivisionType.SIMPLE_MERGED:
			return MeshSubdivision.simple_merged(geometry,subdivision_smooth)
	return null

