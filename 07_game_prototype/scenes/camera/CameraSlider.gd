extends Node
class_name CameraSlider

export(float,0,100) var max_speed = 8.5
export(float,0,50) var acceleration = 0.2
export(float,0,20) var stop_threshold = 0.01
export(float,0,360) var angle_threshold = 90.0
export(bool) var animated = false
export(float,0,300) var offset = 0 setget set_offset, get_offset
export(float,0,1) var unit_offset = 0 setget set_unit_offset, get_unit_offset

var guide : Node setget set_guide;
var camera : Node setget set_camera;
var path : Node setget set_path;

var pathFollow = PathFollow.new()
var look_at_position : Vector3
var current_speed = 0

signal track_started(offset, path)
signal track_finished(offset, path)

func get_offset(): return pathFollow.offset
func set_offset(newVal): pathFollow.offset = newVal
func get_unit_offset(): return pathFollow.unit_offset
func set_unit_offset(newVal): pathFollow.unit_offset = newVal
	
func set_guide(newVal):
	guide = newVal

func set_camera(newVal):
	if camera:
		pathFollow.remove_child(camera)
	camera = newVal
	if camera:
		if camera.get_parent():
			camera.get_parent().remove_child(camera)
		pathFollow.add_child(camera)
	
func set_path(newVal):
	if path:
		path.remove_child(pathFollow)
	path = newVal
	if path:
		if pathFollow.get_parent():
			pathFollow.get_parent().remove_child(pathFollow)
		path.add_child(pathFollow)

func _ready():
	pathFollow.rotation_mode = PathFollow.ROTATION_NONE
	pathFollow.loop = false
	pathFollow.cubic_interp = true

func _physics_process(delta):
	if not initialized():
		return
		
	var camera_position = camera.global_transform.origin
	var guide_position = guide.global_transform.origin
	
	var angle = _get_angle_from_top(camera_position, guide_position)
	look_at_position = Vector3(guide_position.x, guide_position.y, guide_position.z)
	if (angle != angle_threshold):
		look_at_position = Vector3(guide_position.x, guide_position.y, guide_position.z)
		
	if animated:
		return
			
	camera.look_at(look_at_position, Vector3.UP)
	var velocity = _get_x_length(camera_position, guide_position)
	if abs(velocity) > stop_threshold:
		current_speed = lerp(current_speed, max_speed, acceleration)
		self.offset += velocity * delta * current_speed
	else:
		current_speed = 0
		
	if self.unit_offset == 0.0:
		emit_signal("track_started", self.offset, path)
	elif self.unit_offset == 1.0:
		emit_signal("track_finished", self.offset, path)

func initialized() -> bool:
	if not guide:
		return false
	if not camera:
		return false
	if not path:
		return false
	return true
	
func _get_angle_from_top(start, end) -> float:
	return rad2deg(atan2(start.z - end.z, end.x - start.x))

func _get_x_length(start, end) -> float:
	return end.x - start.x
