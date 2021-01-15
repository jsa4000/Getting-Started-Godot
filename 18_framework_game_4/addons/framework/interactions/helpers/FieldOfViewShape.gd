# TODO: Godot4 error loading the resource
#@tool
class_name FieldOfViewShape extends ConvexPolygonShape3D

# TODO: Godot 4 does not allow to set properties for export variables: _set_radius, _set_angle, etc..
@export_range(0,50,0.1) var radius : float = 10.0
@export_range(0,179,1) var angle : float = 90.0
@export_range(0,5,0.1) var size : float = 2.0

func _ready() -> void:
	_update_shape()
	
func _update_shape() -> void:
	points = _create_shape(radius, 180.0 - angle, size)
	
func _create_shape(radius: float, angle: float, size: float) -> PackedVector3Array:
	var x = radius * cos(deg2rad(angle * 0.5))
	var z = radius * sin(deg2rad(angle * 0.5))
	var y = size * 0.5
	return PackedVector3Array([
		Vector3(0,-size,0),
		Vector3(x,-size,z),
		Vector3(-x,-size,z),
		Vector3(-x,size,z),
		Vector3(x,size,z),
		Vector3(0,size,0),
		])
	
func _set_radius(value: float) -> void:
	radius = value
	_update_shape()
	
func _set_angle(value: float) -> void:
	angle = value
	_update_shape()
	
func _set_size(value: float) -> void:
	size = value
	_update_shape()
