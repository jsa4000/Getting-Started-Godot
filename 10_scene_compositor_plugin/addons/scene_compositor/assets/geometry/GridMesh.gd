tool
extends MeshInstance

export(float) var tile_size = 1 setget set_tile_size
export(int) var tile_size_x = 100 setget set_tile_size_x
export(int) var tile_size_z = 100 setget set_tile_size_z
export(float, 0.0, 1.0) var transparency = 0.1 setget set_transparency
export(Color) var color = Color.white setget set_color

func set_tile_size(value):
	tile_size = value
	_generate()

func set_tile_size_x(value):
	tile_size_x = value
	_generate()

func set_tile_size_z(value):
	tile_size_z = value
	_generate()

func set_transparency(value):
	transparency = value
	_generate_material()
	
func set_color(value):
	color = value
	_generate_material()

var _surface_tool : SurfaceTool = SurfaceTool.new()
var _material : Material = SpatialMaterial.new()

func _ready():
	_generate()
	
func _generate():
	_initialize()
	_generate_verticies()
	_generate_indices()
	_generate_mesh()
	_generate_material()

func _initialize():
	_surface_tool.begin(Mesh.PRIMITIVE_LINES)

func _generate_verticies():
	var _vertex = Vector3()
	var _offset_x = tile_size_x / 2;
	var _offset_z = tile_size_z / 2;
	for x in range(tile_size_x):
		for z in range(tile_size_z):
			_vertex = Vector3( (x - _offset_x) * tile_size, 0, (z - _offset_z) * tile_size )
			_surface_tool.add_vertex( _vertex )

func _generate_indices():	
	for x in range(tile_size_x):
		for z in range(tile_size_z):		
			var vertex_index = x * tile_size_x + z
			if z != (tile_size_z - 1):
				_surface_tool.add_index(vertex_index)
				_surface_tool.add_index(vertex_index + 1)
			if x != (tile_size_x - 1):
				_surface_tool.add_index(vertex_index)
				_surface_tool.add_index(vertex_index + tile_size_z)
	
func _generate_mesh():
	self.mesh = _surface_tool.commit()
	
func _generate_material():
	_material.albedo_color = color
	_material.albedo_color.a = transparency
	_material.flags_transparent = true
	_material.flags_unshaded = true
	self.material_override = _material


