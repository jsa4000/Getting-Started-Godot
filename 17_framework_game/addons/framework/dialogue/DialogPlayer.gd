extends Control
class_name DialogPlayer, "../icons/icon_talk.svg"

export(Resource) var dialog_loader : Resource
export(float) var speed = 0.1

onready var text_animation : Tween = $TextAnimation
onready var arrow_animation : AnimationPlayer = $ArrowAnimation
onready var text : RichTextLabel = $ContainerForeground/Background/Text
onready var arrow : TextureRect = $ContainerForeground/Background/Arrow
onready var actor : TextureRect = $ContainerBackground/CenterContainer/Actor

var scene : DialogScene

signal control_opened(scene)
signal control_closed(scene)

func _ready():
	hide()
	dialog_loader.init()
	
func play(script_name: String, scene_name : String) -> void:
	scene = dialog_loader.scripts[script_name][scene_name]
	next()
	show()
	emit_signal("control_opened", scene)
	
func close() -> void:
	hide()
	emit_signal("control_closed",scene)
	
func _process(delta):
	if not is_visible():
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		if  not text_animation.is_active():
			next()
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
	yield(text_animation, "tween_completed")
	_show_arrow(true)
	
func _show_arrow(show) -> void:
	if show:
		arrow.show()
		arrow_animation.play("next")
	else:
		arrow.hide()
		arrow_animation.stop()
