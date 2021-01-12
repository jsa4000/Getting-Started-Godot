extends Spatial
class_name Page

export(PackedScene) var scene

onready var _animationPlayer : AnimationPlayer = $AnimationPlayer
onready var _camera : CameraTrackTo = $CameraTrackTo
onready var _position3D : Position3D = $Position3D
onready var _viewport : Viewport = $Portal/Viewport
onready var _portal : MeshInstance = $Portal
onready var _qteControl : QTEControl = $QTEControl 
onready var _transition : ColorTransition = $ColorTransition 

onready var _portal2 : MeshInstance = $Portal2

var _scene : Node
var _tween : Tween = Tween.new()
var _isQuickTimeEventActive : bool = false

signal change_scene(scene)

func _ready():
	add_child(_tween)
	_scene = scene.instance()
	_viewport.add_child(_scene)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && not _isQuickTimeEventActive:
		_animationPlayer.play("main",-1, 20)	
		#_transitions.play()	
		
	if not _isQuickTimeEventActive:
		return 
		
	if Input.is_action_just_pressed("ui_right"):
		shake()
	if Input.is_action_just_pressed("ui_left"):
		shake()
	if Input.is_action_just_pressed("ui_up"):
		shake()
	if Input.is_action_just_pressed("ui_down"):
		shake()

func _on_QTEControl_completed():
	_set_quick_time_event(false)
	_animationPlayer.play("main",-1, 20)

func stop():
	_set_quick_time_event(true)
	_animationPlayer.stop(false)
	
func change_scene():
	_portal.material_override = _get_screenshot_material()
	emit_signal("change_scene", _scene)
	
func shake(duration : float = 0.05, camera_move: bool = true, target_move : bool = true):
	if not _transition.is_playing:
		_transition.play(Transition.Type.FADE, 5, true, true)
		
	if _tween.is_active():
		return
	var camera_positions = [_camera.global_transform.origin, _get_random_position(_camera.global_transform.origin)]
	var target_positions = [_position3D.global_transform.origin, _get_random_position(_position3D.global_transform.origin)]
	for n in range(2):
		var finished = bool(n)
		if camera_move:
			_tween.interpolate_property(_camera, "translation",
				camera_positions[int(finished)], camera_positions[int(!finished)], duration,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		if target_move:
			_tween.interpolate_property(_position3D, "translation",
				target_positions[int(finished)], target_positions[int(!finished)], duration,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		_tween.start()
		yield(_tween, "tween_completed")

func _get_screenshot_material() -> Material:
	var material = SpatialMaterial.new()
	var texture = ImageTexture.new()
	var image = _viewport.get_texture().get_data()
	image.flip_y()
	texture.create_from_image(image)
	material.albedo_texture = texture
	material.flags_unshaded = true
	return material

func _get_random_position(origin: Vector3, threshold: float = 1.0) -> Vector3:
	var delta = randf() * threshold
	return Vector3(origin.x + delta, origin.y + delta, origin.z + delta)

func _set_quick_time_event(start: bool):
	if start:
		_qteControl.show()
		_qteControl.start(3000)
		_isQuickTimeEventActive = true;
	else:
		_qteControl.hide()
		_isQuickTimeEventActive = false;
	
