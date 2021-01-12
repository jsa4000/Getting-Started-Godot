tool
extends Spatial

enum PrimitiveType {CUBE, SPHERE, PLANE, CYLINDER, CAPSULE, IMPORT }
enum ScriptType {CSHARP, GDSCRIPT }

const MeshToolsScript = preload("res://src/csharp/MeshTools.cs")

export(ScriptType) var script_type = ScriptType.GDSCRIPT setget set_script_type
export(PrimitiveType) var primitive_type = PrimitiveType.CUBE setget set_primitive_type
export(PackedScene) var imported_mesh setget set_imported_mesh
export(int) var subdivisions = 0 setget set_subdivisions
export(bool) var compute_smooth = false setget set_compute_smooth

func set_imported_mesh(value):
	imported_mesh = value
	_generate()

func set_script_type(value):
	script_type = value
	_generate()

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
var mesh_tools = MeshToolsScript.new()

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
	
	var elapsedMs = OS.get_ticks_msec() - start_time
	print("%s Generation has been finished in %s ms" % [ScriptType.keys()[script_type],elapsedMs])

func _subdivide(geometry : MeshInstance) -> MeshInstance:
	var start_time = OS.get_ticks_msec()
	
	for i in range(subdivisions):
		if script_type == ScriptType.CSHARP:
			geometry = mesh_tools.ParallelLinqSubdivide(geometry, false)
		else:
			geometry = MeshUtils.subdivide(geometry, false)
	
	var elapsedMs = OS.get_ticks_msec() - start_time
	print("%s Subdivision level %d has been finished in %s ms" % [ScriptType.keys()[script_type],subdivisions, elapsedMs])

	return geometry

func _smooth(geometry : MeshInstance) -> MeshInstance:
	var start_time = OS.get_ticks_msec()
	
	if script_type == ScriptType.CSHARP:
		geometry = mesh_tools.ParallelLinqSmooth(geometry, 0.0)
	else:
		geometry = MeshUtils.smooth(geometry)
	
	var elapsedMs = OS.get_ticks_msec() - start_time
	print("%s Smooth has been finished in %s ms" % [ScriptType.keys()[script_type],elapsedMs])

	return geometry

func _remove_geometry(geometry : MeshInstance):
	if not geometry:
		return
	remove_child(geometry)
	geometry.queue_free()

func _create_primitive(primitive_type : int =  -1) -> MeshInstance:
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
