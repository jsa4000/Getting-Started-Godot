extends Spatial
class_name CustomPathFollow

export(float,0,10000) var offset = 0 setget set_offset
export(float,0,100)var h_offset = 0 setget set_h_offset
export(float,0,100) var v_offset = 0 setget set_v_offset
export(float,0,1) var unit_offset = 0 setget set_unit_offset, get_unit_offset
export(bool) var cubic = false setget set_cubic
var path : Path setget set_path
	
func set_path(newVal): 
	path = newVal	
	
func set_h_offset(newVal): 
	h_offset = newVal
	if path:
		_update_transform()
	
func set_v_offset(newVal): 
	v_offset = newVal
	if path:
		_update_transform()
	
func set_offset(newVal): 
	offset = newVal;
	if path && path.get_curve() :
		var path_length = path.get_curve().get_baked_length()
		offset = clamp(offset, 0, path_length)
		_update_transform()
		
func set_unit_offset(newVal):
	if path && path.get_curve() && path.get_curve().get_baked_length():
		self.offset = newVal * path.get_curve().get_baked_length()
	
func get_unit_offset() -> float:
	if path && path.get_curve() && path.get_curve().get_baked_length():
		return offset / path.get_curve().get_baked_length()
	else:
		return 0.0
	
func set_cubic(newVal): 
	cubic = newVal

func _ready():
	offset = 0
	unit_offset = 0
	
func _update_transform():
	if not path:
		return
	var curve = path.get_curve();
	if not curve:
		return

	#var pos = curve.interpolate_baked(offset, cubic)
	var pos = _interpolate_baked(curve, offset, cubic)
	var transform = get_transform()
	transform.origin = pos + Vector3(h_offset, v_offset, 0)
	set_transform(transform)

func _interpolate_baked(curve: Curve3D, offset : float, cubic : bool) -> Vector3:
	var baked_points = curve.get_baked_points()
	if not baked_points.size():
		return Vector3.ZERO
	elif baked_points.size() == 1:
		return baked_points[0]

	if offset < 0:
		return baked_points[0]
	if offset >= curve.get_baked_length():
		return baked_points[baked_points.size() - 1]
		
	var index = floor(offset / curve.bake_interval)
	var frac = fmod(offset, curve.bake_interval);

	if index >= baked_points.size() - 1:
		return baked_points[baked_points.size() - 1]
	elif index == baked_points.size() - 2:
		if frac > 0:
			frac /= fmod(curve.get_baked_length(), curve.bake_interval)
	else:
		frac /= curve.bake_interval

	if cubic:
		var pre = baked_points[index - 1] if index > 0 else baked_points[index]
		var post = baked_points[index + 2] if index < (baked_points.size() - 2) else baked_points[index + 1]
		return baked_points[index].cubic_interpolate(baked_points[index + 1], pre, post, frac)
	else:
		if curve.resource_path == "res://scenes/worlds/World.tscn::9":
			var point = baked_points[index].linear_interpolate(baked_points[index + 1], frac)
			print("With offset %d goes from Index %d, frac %d, Point %s" % [offset, index,frac,point])
		return baked_points[index].linear_interpolate(baked_points[index + 1], frac)
