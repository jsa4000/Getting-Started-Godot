tool
extends MeshInstance

export(float) var axis_size = 2 setget set_axis_size
export(float, 0.0, 1.0) var transparency = 0.5 setget set_transparency

func set_axis_size(value):
	axis_size = value
	_generate()
	
func set_transparency(value):
	transparency = value
	_generate_material()

var _surface_tool : SurfaceTool = SurfaceTool.new()
var _material : Material = SpatialMaterial.new()

func _ready():
	_generate()
	
func _generate():
	_initialize()
	_generate_verticies()
	_generate_mesh()
	_generate_material()

func _initialize():
	_surface_tool.begin(Mesh.PRIMITIVE_LINES)

func _generate_verticies():	
	_surface_tool.add_color(Color.red)
	_surface_tool.add_vertex(Vector3(-axis_size, 0, 0))
	_surface_tool.add_vertex(Vector3(axis_size, 0, 0))
	_surface_tool.add_color(Color.green)
	_surface_tool.add_vertex(Vector3(0, -axis_size, 0))
	_surface_tool.add_vertex(Vector3(0, axis_size, 0))
	_surface_tool.add_color(Color.blue)
	_surface_tool.add_vertex(Vector3(0, 0, -axis_size))
	_surface_tool.add_vertex(Vector3(0, 0, axis_size))

func _generate_indices():	
	_surface_tool.index()
	
func _generate_mesh():
	self.mesh = _surface_tool.commit()
	
func _generate_material():
	_material.albedo_color = Color.white
	_material.albedo_color.a = transparency
	_material.flags_transparent = true
	_material.flags_unshaded = true
	_material.vertex_color_use_as_albedo = true
	self.material_override = _material


