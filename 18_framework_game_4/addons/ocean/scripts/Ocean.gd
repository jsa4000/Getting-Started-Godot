@tool
class_name Ocean extends MeshInstance3D
@icon("../icons/water.svg")

const WaterMaterial = preload("res://addons/ocean/assets/material/water_material.tres")
const DefaultSize = Vector2(10,10)

func _ready():
	if mesh == null: 
		mesh = _create_plane()	
	# TODO: Error in Godot 4.0 with SpatialShader Type
	#material_override = WaterMaterial
	set_surface_material(0,WaterMaterial)

func _create_plane() -> Mesh:
	var mesh = PlaneMesh.new()
	mesh.size = DefaultSize
	return mesh
