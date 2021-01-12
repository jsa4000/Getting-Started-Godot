extends Node
class_name PortalManager

export(float,0,1) var initial_offset = 0
export(int) var initial_portal = 0

export(NodePath) var player_path;
export(NodePath) var camera_path;
export(Array, NodePath) var portal_paths;

onready var player : Actor = get_node(player_path)
onready var camera : Camera = get_node(camera_path)
onready var slider : CameraSlider = get_slider()
onready var portals : Array = get_portals()
var current_portal : Portal

func _get_configuration_warning():
	var warnings = PoolStringArray([])
	if not get_slider():
		warnings.append("%s is missing a Camera Slider to control the camera movement. Consider adding a CameraSlider" % name)
	return warnings.join("\n")

func get_portals() -> Array:
	var list = []
	for path in portal_paths:
		var portal = get_node(path)
		portal.camera = camera
		portal.player = player
		portal.slider = slider
		portal.connect("body_entered", self, "_on_body_entered")
		list.append(portal)
	return list

func get_slider() -> CameraSlider:
	var slider : CameraSlider
	var sliders = TreeUtils.get_children_by_type(self, CameraSlider)
	if not sliders || not sliders.size():
		slider = CameraSlider.new()
	else:
		slider = sliders[0]
	slider.connect("track_started", self, "_on_track_started")
	slider.connect("track_finished", self, "_on_track_finished")
	add_child(slider)
	return slider

func _ready():
	pass
	
func _process(delta):
	if slider && not slider.initialized():
		slider.camera = camera
		slider.guide = player
		set_portal(portals[initial_portal], initial_offset, null, null, false)

func set_portal(portal, unit_offset = initial_offset, offset = null, transition = null, calibrate_camera = true):
	if not portal:
		return
	current_portal = portal
	var camera_position = camera.global_transform.origin;
	var camera_look_at = slider.look_at_position;
	slider.path = portal
	if not offset:
		slider.unit_offset = unit_offset
	else:
		slider.offset = offset
	slider.animated = portal.transition_enabled
	#logPath(camera, portal, slider)
	if calibrate_camera:
		camera.global_transform.origin = camera_position
		camera.look_at(camera_look_at, Vector3.UP)
	if portal.transition_enabled && transition:
		transition.play()
		yield(transition,"transition_completed")
		calibrate_camera(camera.global_transform.origin, player.global_transform.origin, 0.5)
		slider.animated = false

func calibrate_camera(position : Vector3, target : Vector3, time : float = 1, animated : bool = false):
	var transform : Transform
	transform.origin = camera.global_transform.origin
	var original_scale = camera.get_scale()
	transform = transform.looking_at(target, Vector3.UP)
	
	slider.animated = true
	var animation = Tween.new()
	add_child(animation)
	animation.interpolate_property(
		camera, "global_transform:origin", 
		camera.global_transform.origin, position, time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	animation.interpolate_property(camera, "global_transform",
		camera.global_transform, transform , time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	animation.interpolate_property(camera, "scale",
		camera.scale, original_scale , time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	animation.start()
	yield(animation, "tween_completed")
	remove_child(animation)
	animation.queue_free()
	if not animated:
		slider.animated = false

func _look_at(origin : Spatial, target : Vector3, up_vector : Vector3):
	var position : Vector3 = origin.global_transform.origin
	if position == target:
		print("Node origin and target are in the same position, look_at() failed")
		return 

	if up_vector.cross(target - position) == Vector3():
		print("Up vector and direction between node origin and target are aligned, look_at() failed")
		return 
	
	var transform : Transform
	transform.origin = position
	var original_scale = origin.get_scale()
	transform = transform.looking_at(target, up_vector)
	origin.set_global_transform(transform)
	origin.set_scale(original_scale)

func _on_body_entered(portal, body, direction, transition):
	set_portal(portal, direction, null, transition, true)
	
func _on_track_started(offset, portal):
	if portal.chain_portal_start:	
		set_portal(portal.chain_portal_start, null, _get_closest_offset(portal, portal.chain_portal_start), portal.chain_portal_start.transition, true)
	elif portal.chain_scene_start:
		get_tree().change_scene_to(portal.chain_scene_start)
	
func _on_track_finished(offset, portal):
	if portal.chain_portal_end:	
		set_portal(portal.chain_portal_end, null, _get_closest_offset(portal, portal.chain_portal_end), portal.chain_portal_end.transition, true)
	elif portal.chain_scene_end:
		get_tree().change_scene_to(portal.chain_scene_end)
	
func _get_closest_offset(from_portal, to_portal):
	return to_portal.curve.get_closest_offset(from_portal.curve.get_point_position(from_portal.curve.get_point_count() - 1))
		
func logPath(camera, path, slider, text = "Portal Manager Information"):		
	print()
	print("[DEBUG] %s" % text)
	print("Camera Position %s" % camera.global_transform.origin)
	print("Tracker Current Offset %d" % slider.offset)
	print("Tracker Current Unit Offset %d" % slider.unit_offset)
	print("Path Position %s" % path.global_transform.origin)
	print("Path points number %d" % path.curve.get_point_count())
	print("First Path Point: Transform %s, Real: %s" % [path.curve.get_point_position(0) + path.global_transform.origin, path.curve.get_point_position(0)])
	print("Last Path Point: Transform %s, Real: %s" % [path.curve.get_point_position(path.curve.get_point_count() - 1) + path.global_transform.origin, path.curve.get_point_position(path.curve.get_point_count() - 1)])

