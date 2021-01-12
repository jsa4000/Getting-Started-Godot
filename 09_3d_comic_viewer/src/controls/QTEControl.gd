tool
extends Control
class_name QTEControl

export(float,0,2) var scale = 1.0 setget set_proportional_scale

var _started : bool = false
var _started_at : int
var _duration : int
onready var _textureButtonPressed = load("res://assets/buttons/button_pressed.png")
onready var _textureButtonNormal = load("res://assets/buttons/button_normal.png")
onready var _buttonImage : TextureRect = $Button/ButtonImage
onready var _progressBar : TextureProgress = $Button/Progressbar
onready var _Arrow : TextureRect = $Button/Arrow

func set_proportional_scale(value: float):
	scale = value
	self.rect_scale = Vector2(value,value)

signal completed

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
		
	if not _started:
		return
		
	if Input.is_action_just_pressed("ui_right"):
		_press_button(true)
		print("right button has been pressed")
	if Input.is_action_just_released("ui_right"):
		_press_button(false)
		print("right button has been released")
		
	_update_progress_bar()

func start(milliseconds: int):
	_started_at = OS.get_system_time_msecs()
	_duration = milliseconds
	_started = true
	
func _press_button(pressed: bool):
	if pressed:
		_buttonImage.texture = _textureButtonPressed
	else:
		_buttonImage.texture = _textureButtonNormal

func _update_progress_bar():
	if _progressBar.value == _progressBar.max_value:
			emit_signal("completed")
			_started = false
			_progressBar.value = _progressBar.min_value
	else:
		var current_time = OS.get_system_time_msecs()
		_progressBar.value = (float(current_time - _started_at) / float(_duration)) * 100.0
