tool
extends MeshInstance
class_name Ocean, "../icons/water.svg"

const WaterMaterial = preload("res://addons/ocean/assets/material/water_material.tres")
const DefaultSize = Vector2(10,10)

func _ready():
	if mesh == null: 
		mesh = _create_plane()
	material_override = WaterMaterial

func _create_plane() -> Mesh:
	var mesh = PlaneMesh.new()
	mesh.size = DefaultSize
	return mesh
