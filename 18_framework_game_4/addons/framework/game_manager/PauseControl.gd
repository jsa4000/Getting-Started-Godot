@tool
class_name PauseControl extends Control
@icon("../icons/pause.svg")

enum Options {RESUME, SETTINGS, MENU}

@export var enabled : bool = false
@export var game_delegate : Resource
@export_range(0,10,0.1) var transition_speed : float = 4.0
@export var custom_font: Font

@onready var _container : Control = $CanvasLayer/Container
@onready var _player : AnimationPlayer = $AnimationPlayer
@onready var _options : Array = [
	$CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/Resume,
	$CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/Settings,
	$CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/Menu
	]

var _current_selection : int = 0
var _is_paused = false

# TODO: Godot 4 error havinf this into the constructor. Adding super() does not nothing
#func _init():
#	if not visibility_changed.is_connected(_on_visibility_changed):
#		visibility_changed.connect(_on_visibility_changed)

func _ready():
	_set_pause_mode(Node.PAUSE_MODE_PROCESS)
	_set_enabled(enabled)
	_set_visible(false)
	if Engine.is_editor_hint():
		return
	_set_selection(_current_selection)
	_set_custom_font(custom_font)

func _process(delta):
	if Engine.is_editor_hint():
		return
		
	if Input.is_action_just_pressed("ui_cancel"):
		await pause(!visible)
	
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
		await _execute_selection(_current_selection)
	
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
		# TODO: Godot 4.0 throws an error whether using await or not
		#await _player.animation_finished
		_set_visible(enable)

func _set_visible(value : bool) -> void:
	_container.visible = value
	visible = value

func _set_enabled(value : bool) -> void:
	_enable_process(value)

func _enable_process(enable : bool) -> void:
	if Engine.is_editor_hint():
		enable = false
	set_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)

func _on_visibility_changed():
	_set_visible(visible)

func _execute_selection(index : int) -> void:
	# TODO: Gooot 4 select sentences does not work. 
	# TODD: Gooot 4 Enums also cannnot be directly compared with integers
#	match index:
#		Options.RESUME:
#			await pause(false)
#		Options.SETTINGS:		
#			pass
#		Options.MENU:
#			await pause(false)
#			game_delegate.change_mode(GameDelegate.Mode.MENU)
	if index == int(Options.RESUME):
		await pause(false)
	elif index == int(Options.MENU):
		await pause(false)
		game_delegate.change_mode(GameDelegate.Mode.MENU)

func _set_custom_font(value : Font) -> void:
	for i in range(_options.size()):
		_options[i].set("custom_fonts/font",custom_font)

func _set_pause_mode(mode : int):
	pause_mode = mode

func _set_selection(index : int) -> void:
	for i in range(_options.size()):
		if i == index:
			_options[i].set("custom_font_sizes/font_size",40)
			_options[i].set("custom_constants/outline_size",1)
		else:
			_options[i].set("custom_font_sizes/font_size",25)
			_options[i].set("custom_constants/outline_size",0)
