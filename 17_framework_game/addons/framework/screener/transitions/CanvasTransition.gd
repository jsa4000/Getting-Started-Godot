extends Node
class_name CanvasTransition

enum Type { FADE, CURTAIN, FROM_CENTER, SHARDS}

export(Type) var type = Type.FADE
export(float,0,1) var offset : float = 0.0 setget set_offset
export(float,0,1) var blur : float = 0.4
export(int,0,30000) var duration : int = 1000
export(bool) var inverted = true
export(bool) var backAndForth = false
export(bool) var onTop = true
export(int) var transitionType = Tween.TRANS_LINEAR
export(int) var easeType =  Tween.EASE_IN_OUT
export(bool) var hideOnCompleted = false

var is_playing : bool = false

onready var EmptyTexture = preload("res://addons/framework/screener/masks/empty.png")
onready var CurtainTexture = preload("res://addons/framework/screener/masks/curtain.png")
onready var FromCenterTexture = preload("res://addons/framework/screener/masks/from_center.png")
onready var ShardsTexture = preload("res://addons/framework/screener/masks/shards.png")

onready var _tween : Tween = $Tween
onready var _canvasLayer : CanvasLayer = $CanvasLayer
onready var _screen : ColorRect = $CanvasLayer/Screen

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
	
func _play():
	is_playing = true
	var values = [0.0, 1.0]
	if inverted:
		values.invert()
	set_offset(values[0])
	_tween.interpolate_property(_screen.material, "shader_param/cutoff",
		values[0], values[1], _to_seconds(duration),
		transitionType, easeType)
	_tween.start()
	
	if  backAndForth:	
		yield(_tween, "tween_completed")
		emit_signal("step_completed")
		_tween.interpolate_property(_screen.material, "shader_param/cutoff",
			values[1], values[0], _to_seconds(duration),
			transitionType, easeType)
		_tween.start()

	yield(_tween, "tween_completed")
	emit_signal("step_completed")

	if hideOnCompleted:
		_screen.hide()
	is_playing = false
	emit_signal("all_completed")

func _set_shader_mask(type):
	match type:
		Type.FADE:
			_screen.material.set_shader_param("mask", EmptyTexture)
		Type.CURTAIN:
			_screen.material.set_shader_param("mask", CurtainTexture)
		Type.FROM_CENTER:
			_screen.material.set_shader_param("mask", FromCenterTexture)
		Type.SHARDS:
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
