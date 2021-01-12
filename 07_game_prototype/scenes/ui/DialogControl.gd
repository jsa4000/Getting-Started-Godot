extends Control
class_name DialogControl

export(float) var speed = 0.1

onready var text_animation : Tween = $Dialog/TextAnimation
onready var arrow_animation : AnimationPlayer = $Dialog/ArrowAnimation
onready var text : RichTextLabel = $Dialog/Text
onready var arrow : TextureRect = $Dialog/Arrow
onready var actor : TextureRect = $Actor

var scene : DialogScene

signal control_opened(scene)
signal control_closed(scene)

func _ready():
	DialogManager.set_control(self)
	
func open(new_scene):
	if not new_scene:
		print("Error Scene cannot be opened")
	scene = new_scene
	next()
	show()
	emit_signal("control_opened", scene)
	
func close():
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
			show_arrow(true)
	
func next():
	if not scene.items.has(scene.current):
		if scene.current:
			print("No item found %s in scene %s" % [scene.current, scene.id])
		scene.current = scene.default
		close()
		return
	show_arrow(false)
	var item = scene.items[scene.current]
	text.bbcode_text  = item.text
	text.percent_visible = 0
	actor.texture = item.texture
	scene.current = item.next
	_play_text_animation()
	
func _play_text_animation():
	text_animation.interpolate_property(text, "percent_visible",
		0, 1, speed * text.bbcode_text.length(),
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	text_animation.start()
	yield(text_animation, "tween_completed")
	show_arrow(true)
	
func show_arrow(show):
	if show:
		arrow.show()
		arrow_animation.play("next")
	else:
		arrow.hide()
		arrow_animation.stop()
