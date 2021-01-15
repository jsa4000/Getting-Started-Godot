@tool
class_name DialogPlayer extends Control
@icon("../icons/icon_talk.svg")

@export var dialog_loader : Resource
@export_range(0,100,0.1) var speed : float = 0.1

@onready var text_animation : Tween = $TextAnimation
@onready var arrow_animation : AnimationPlayer = $ArrowAnimation
@onready var text : RichTextLabel = $ContainerForeground/Background/Text
@onready var arrow : TextureRect = $ContainerForeground/Background/Arrow
@onready var actor : TextureRect = $ContainerBackground/CenterContainer/Actor

var scene : DialogScene

signal control_opened(scene)
signal control_closed(scene)

func _ready():
	hide()
	if Engine.is_editor_hint():
		return
	# TODO: Godot 4.0 Error using await with tweens. Used signals instead
	text_animation.tween_completed.connect(_on_tween_completed)
	dialog_loader.init()
	
func play(script_name: String, scene_name : String) -> void:
	scene = dialog_loader.scripts[script_name][scene_name]
	await next()
	show()
	control_opened.emit(scene)
	
func close() -> void:
	hide()
	control_closed.emit(scene)
	
func _process(delta):
	if not is_visible() || Engine.is_editor_hint():
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		if  not text_animation.is_active():
			await next()
		else:
			text_animation.remove_all()
			text.percent_visible = 1
			_show_arrow(true)
	
func next() -> void:
	if not scene.items.has(scene.current):
		if scene.current:
			print("No item found %s in scene %s" % [scene.current, scene.id])
		scene.current = scene.default
		close()
		return
	_show_arrow(false)
	var item = scene.items[scene.current]
	text.bbcode_text  = item.text
	text.percent_visible = 0
	actor.texture = item.texture
	scene.current = item.next
	_play_text_animation()
	
func _play_text_animation() -> void:
	text_animation.interpolate_property(text, "percent_visible",
		0, 1, speed * text.bbcode_text.length(),
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	text_animation.start()
	# TODO: Godot 4.0 Error using await with tweens. Used signals instead
	#await text_animation.tween_completed
	#_show_arrow(true)

func _on_tween_completed(object: Object, key: NodePath):
	_show_arrow(true)
	
func _show_arrow(show) -> void:
	if show:
		arrow.show()
		arrow_animation.play("next")
	else:
		arrow.hide()
		arrow_animation.stop()
