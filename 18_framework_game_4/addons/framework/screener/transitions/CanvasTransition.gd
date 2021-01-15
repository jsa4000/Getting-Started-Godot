@tool
class_name CanvasTransition extends Node

enum Type { FADE, CURTAIN, FROM_CENTER, SHARDS}
enum TransitionState {INITIAL, STARTED, BACK_AND_FORTH, FINISHED}

# TODO: Godot 4 does not allow to specify the enum type even it is mentionedd in the documentation (Type)
@export var type : int = Type.FADE
@export_range(0,1,0.01) var offset : float = 0.0
@export_range(0,1,0.01) var blur : float = 0.4
@export_range(0,30000) var duration : int = 1000
@export var inverted : bool = true
@export var backAndForth : bool = false
@export var onTop : bool = true
@export var transitionType : int = Tween.TRANS_LINEAR
@export var easeType : int =  Tween.EASE_IN_OUT
@export var hideOnCompleted : bool = false

var is_playing : bool = false

@onready var EmptyTexture = preload("res://addons/framework/screener/masks/empty.png")
@onready var CurtainTexture = preload("res://addons/framework/screener/masks/curtain.png")
@onready var FromCenterTexture = preload("res://addons/framework/screener/masks/from_center.png")
@onready var ShardsTexture = preload("res://addons/framework/screener/masks/shards.png")

@onready var _tween : Tween = $Tween
@onready var _canvasLayer : CanvasLayer = $CanvasLayer
@onready var _screen : ColorRect = $CanvasLayer/Screen

var _current_state : int = TransitionState.INITIAL

signal all_completed
signal step_completed

func set_offset(value: float):
	offset = value
	if not is_inside_tree():
		return
	_set_shader_cutoff(offset)

func _ready():
	if not is_inside_tree():
		return
	# TODO: Godot 4.0 Error using await with tweens. Used signals instead
	#_tween.tween_completed.connect(_on_tween_completed)
	_set_on_top(onTop)
	_init_shader()
	_screen.hide()
		
func _init_shader():
	_set_shader_mask(type)
	_set_shader_blur(blur)

func play():
	_init_shader()
	_screen.show()
	_play()
	
func reset() -> void:
	if inverted:
		set_offset(1)
	else:
		set_offset(0)

func _play(state : int = TransitionState.INITIAL):
	is_playing = true
	var values = [0.0, 1.0]
	if inverted:
		values.invert()
	set_offset(values[0])
	# TODO: Godot4 Error with Material should be an object
	# TODO: JSA400 Check how to acceso to materiaal from _screen
	#_tween.interpolate_property(_screen.material, "shader_param/cutoff",
	_tween.interpolate_property(_screen, "material:shader_param/cutoff",
		values[0], values[1], _to_seconds(duration),
		transitionType, easeType)
	_tween.start()

	if  backAndForth:	
		# TODO: Godot 4.0 Error using await with tweens. Used signals instead
		#await _tween.tween_completed
		step_completed.emit()
		# TODO: Godot4 Error with Material should be an object
		# TODO: JSA400 Check how to acceso to materiaal from _screen
		#_tween.interpolate_property(_screen.material, "shader_param/cutoff",
		_tween.interpolate_property(_screen, "material:shader_param/cutoff",
			values[1], values[0], _to_seconds(duration),
			transitionType, easeType)
		_tween.start()

	# TODO: Godot 4.0 Error using await with tweens. Used signals instead
	#await _tween.tween_completed
	step_completed.emit()

	if hideOnCompleted:
		_screen.hide()
	is_playing = false
	all_completed.emit()

#func _play(state : int = TransitionState.INITIAL):
#	is_playing = true
#	var values = [0.0, 1.0]
#	if inverted:
#		values.invert()
#	# TODO: Godot 4.0 select statement does not work correctly
#	# TODO: Godot 4.0 Enums must be casted to integer to be compared
#	if state == int(TransitionState.INITIAL):
#		set_offset(values[0])
#		# TODO: Godot4 Error with Material should be an object
#		# TODO: JSA400 Check how to acceso to materiaal from _screen
#		#_tween.interpolate_property(_screen.material, "shader_param/cutoff",
#		_tween.interpolate_property(_screen, "material:shader_param/cutoff",
#			values[0], values[1], _to_seconds(duration),
#			transitionType, easeType)
#		_tween.start()
#		_current_state = TransitionState.STARTED
#	elif state == int(TransitionState.STARTED) || state == int(TransitionState.BACK_AND_FORTH) :
#		if backAndForth && state != int(TransitionState.BACK_AND_FORTH):	
#			# TODO: Godot 4.0 Error using await with tweens. Used signals instead
#			#await _tween.tween_completed
#			step_completed.emit()
#			# TODO: Godot4 Error with Material should be an object
#			# TODO: JSA400 Check how to acceso to materiaal from _screen
#			#_tween.interpolate_property(_screen.material, "shader_param/cutoff",
#			_tween.interpolate_property(_screen, "material:shader_param/cutoff",
#				values[1], values[0], _to_seconds(duration),
#				transitionType, easeType)
#			_tween.start()
#			_current_state = TransitionState.BACK_AND_FORTH
#			return
#		# TODO: Godot 4.0 Error using await with tweens. Used signals instead
#		#await _tween.tween_completed
#		step_completed.emit()
#
#		if hideOnCompleted:
#			_screen.hide()
#		is_playing = false
#		all_completed.emit()
#		_current_state = TransitionState.FINISHED
#
#func _on_tween_completed(object: Object, key: NodePath):
#	_play(_current_state)

func _set_shader_mask(type):
#	match type:
#		Type.FADE:
#			_screen.material.set_shader_param("mask", EmptyTexture)
#		Type.CURTAIN:
#			_screen.material.set_shader_param("mask", CurtainTexture)
#		Type.FROM_CENTER:
#			_screen.material.set_shader_param("mask", FromCenterTexture)
#		Type.SHARDS:
#			_screen.material.set_shader_param("mask", ShardsTexture)
	if type == int(Type.FADE):
		_screen.material.set_shader_param("mask", EmptyTexture)
	elif type == int(Type.CURTAIN):
		_screen.material.set_shader_param("mask", CurtainTexture)
	elif type == int(Type.FROM_CENTER):
		_screen.material.set_shader_param("mask", FromCenterTexture)
	elif type == int(Type.SHARDS):
		_screen.material.set_shader_param("mask", ShardsTexture)
			
func _set_shader_blur(blur: float):
	_screen.material.set_shader_param("blur", blur)
	
func _set_shader_cutoff(offset: float):
	_screen.material.set_shader_param("cutoff", offset)
	
func _to_seconds(milliseconds: int) -> float:
	return float(milliseconds) / 1000.0
	
func _set_on_top(enable: bool):
	if enable:
		_canvasLayer.layer = 100
	else:
		_canvasLayer.layer = -1
