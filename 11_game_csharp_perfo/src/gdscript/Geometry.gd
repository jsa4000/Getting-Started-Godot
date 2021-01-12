tool
extends Spatial

enum PrimitiveType {CUBE, SPHERE, PLANE, CYLINDER, CAPSULE }

export(PrimitiveType) var primitive_type = PrimitiveType.CUBE setget set_primitive_type
export(int) var subdivisions = 0 setget set_subdivisions
export(bool) var compute_smooth = false setget set_compute_smooth

func set_subdivisions(value):
	subdivisions = value
	_generate()

func set_compute_smooth(value):
	compute_smooth = value
	_generate()

func set_primitive_type(value):
	primitive_type = value
	_generate()

var geometry : MeshInstance = null

func _ready():
	_generate()

func _generate():
	if not is_inside_tree():
		return
	
	var start_time = OS.get_ticks_msec()
	
	_remove_geometry(geometry)
	geometry = _create_primitive(primitive_type)
	geometry = _subdivide(geometry)
	if compute_smooth:
		geometry = _smooth(geometry)
	add_child(geometry)

	"""

	Subdivide (SurfaceTool)

	Set subdivisions 1
	Action has been finished in 137 ms
	GDScript Generation has been finished in 143 ms
	Set subdivisions 2 
	Action has been finished in 864 ms
	GDScript Generation has been finished in 869 ms
	Set subdivisions 3
	Action has been finished in 3972 ms
	GDScript Generation has been finished in 3978 ms
	Set subdivisions 4
	Action has been finished in 16772 ms
	GDScript Generation has been finished in 16778 ms
	Set subdivisions 5
	Action has been finished in 72963 ms
	GDScript Generation has been finished in 72968 ms  // 25.952.510

	Subdivide (ArrayMesh)
	
	Set subdivisions 1
	Action has been finished in 69 ms
	GDScript Generation has been finished in 76 ms
	Set subdivisions 2
	Action has been finished in 330 ms
	GDScript Generation has been finished in 337 ms
	Set subdivisions 3
	Action has been finished in 1412 ms
	GDScript Generation has been finished in 1419 ms
	Set subdivisions 4
	Action has been finished in 5761 ms
	GDScript Generation has been finished in 5767 ms
	Set subdivisions 5
	Action has been finished in 23516 ms
	GDScript Generation has been finished in 23521 ms
	Set subdivisions 6
	Action has been finished in 95715 ms
	GDScript Generation has been finished in 95722 ms


	"""
	
	var elapsedMs = OS.get_ticks_msec() - start_time
	print("GDScript Generation has been finished in %s ms" % elapsedMs)

func _subdivide(geometry : MeshInstance) -> MeshInstance:
	var start_time = OS.get_ticks_msec()
	
	for i in range(subdivisions):
		geometry = MeshUtils.subdivide(geometry, false)
	
	var elapsedMs = OS.get_ticks_msec() - start_time
	print("Action has been finished in %s ms" % elapsedMs)

	return geometry

func _smooth(geometry : MeshInstance) -> MeshInstance:
	var start_time = OS.get_ticks_msec()
	
	geometry = MeshUtils.smooth(geometry)
	
	var elapsedMs = OS.get_ticks_msec() - start_time
	print("Action has been finished in %s ms" % elapsedMs)

	return geometry

func _remove_geometry(geometry : MeshInstance):
	if not geometry:
		return
	remove_child(geometry)
	geometry.queue_free()

func _create_primitive(primitive_type : int =  -1) -> MeshInstance:
	var mesh : Mesh
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
