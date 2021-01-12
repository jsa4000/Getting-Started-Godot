tool
extends Control
class_name PauseControl, "../icons/pause.svg"

enum Options {RESUME, SETTINGS, MENU}

export (bool) var enabled : bool = false setget _set_enabled
export(Resource) var game_delegate : Resource
export (float,0,10) var transition_speed : float = 4.0
export(Font) var theme_option_enabled : Font
export(Font) var theme_option_disabled : Font

onready var _container : Control = $CanvasLayer/Container
onready var _player : AnimationPlayer = $AnimationPlayer
onready var _options : Array = [
	$CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/Resume,
	$CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/Settings,
	$CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/Menu
	]

var _current_selection : int = 0
var _is_paused = false

func _init():
	if not is_connected("visibility_changed",self,"_on_visibility_changed"):
		connect("visibility_changed",self,"_on_visibility_changed")

func _ready():
	_set_enabled(enabled)
	_set_visible(false)
	_set_selection(_current_selection)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause(!visible)
		
	if not _is_paused:
		return
		
	if Input.is_action_just_pressed("ui_down"):
		if _current_selection < _options.size() - 1:
			_current_selection += 1
			_set_selection(_current_selection)
	elif Input.is_action_just_pressed("ui_up"):
		if _current_selection > 0:
			_current_selection -= 1
			_set_selection(_current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		_execute_selection(_current_selection)
	
func pause(enable : bool) -> void:
	if enable:
		_is_paused = true
		game_delegate.pause(self)
		_set_visible(enable)
		_player.play("Open",-1,4)
	else:
		_is_paused = false
		game_delegate.resume(self)
		_player.play("Close",-1,4)
		yield(_player,"animation_finished")
		_set_visible(enable)

func _set_visible(value : bool) -> void:
	_container.visible = value
	visible = value

func _set_enabled(value : bool) -> void:
	enabled = value
	_enable_process(enabled)

func _enable_process(enable : bool) -> void:
	if Engine.is_editor_hint():
		enable = false
	set_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)

func _on_visibility_changed():
	_set_visible(visible)

func _execute_selection(index : int) -> void:
	match index:
		Options.RESUME:
			pause(false)
		Options.SETTINGS:
			pass
		Options.MENU:
			pause(false)
			game_delegate.change_mode(GameDelegate.Mode.MENU)
			
func _set_selection(index : int) -> void:
	for i in range(_options.size()):
		if i == index:
			_options[i].set("custom_fonts/font",theme_option_enabled)
		else:
			_options[i].set("custom_fonts/font",theme_option_disabled)

