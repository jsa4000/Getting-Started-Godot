extends Spatial
class_name CameraGimbal

export (NodePath) var viewport_path = null

export (float, 0.0, 2.0) var rotation_speed = PI/2
export (float, 0.001, 0.1) var mouse_sensitivity = 0.02
export (bool) var invert_y = true
export (bool) var invert_x = true

export (float) var max_zoom = 10.0
export (float) var min_zoom = 0.4
export (float, 0.05, 1.0) var zoom_speed = 0.5

var _viewport : Node = null
var mouse_enabled = false
var zoom = 1.5

onready var camera : Camera = $InnerGimbal/Camera
onready var inner_gimbal : Spatial = $InnerGimbal

func _ready():
	_initialize_viewport()

func _initialize_viewport():
	if viewport_path == null:
		return
	_viewport = get_node(viewport_path)
	_viewport.connect("mouse_entered", self, "_on_viewport_mouse_entered")
	_viewport.connect("mouse_exited", self, "_on_viewport_mouse_exited")

func _notification(event):
	if _viewport != null:
		return
	match event:
		NOTIFICATION_WM_MOUSE_EXIT:
			mouse_enabled = false
		NOTIFICATION_WM_MOUSE_ENTER:
			mouse_enabled = true

func _process(delta):
	if not is_inside_tree():
		return
	inner_gimbal.rotation.x = clamp(inner_gimbal.rotation.x, -1.4, -0.01)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)

func _input(event):
	if not mouse_enabled:
		return
	if event is InputEventMagnifyGesture:
		zoom += 1.0 - event.factor
		zoom = clamp(zoom, min_zoom, max_zoom)
	if event is InputEventPanGesture:
		if event.delta.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.delta.x * mouse_sensitivity)
		if event.delta.y != 0:
			var dir = 1 if invert_y else -1
			var y_rotation = clamp(event.delta.y, -30, 30)
			inner_gimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)
		
func _on_viewport_mouse_entered():
	mouse_enabled = true
	
func _on_viewport_mouse_exited():
	mouse_enabled = false
