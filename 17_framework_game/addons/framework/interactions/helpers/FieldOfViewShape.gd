tool
extends ConvexPolygonShape
class_name FieldOfViewShape

export(float,0,50,0.1) var radius = 10.0 setget _set_radius
export(float,0,179,1) var angle = 90.0 setget _set_angle
export(float,0,5,0.1) var size = 2.0 setget _set_size

func _ready() -> void:
	_update_shape()
	
func _update_shape() -> void:
	points = _create_shape(radius, 180.0 - angle, size)
	
func _create_shape(radius: float, angle: float, size: float) -> PoolVector3Array:
	var x = radius * cos(deg2rad(angle * 0.5))
	var z = radius * sin(deg2rad(angle * 0.5))
	var y = size * 0.5
	return PoolVector3Array([
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
