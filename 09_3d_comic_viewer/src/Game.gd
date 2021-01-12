extends Spatial

const MAIN_SCENE : String =  "res://src/pages/Page01.tscn"

onready var _frontViewport : Viewport = $Front/Viewport
onready var _backViewport : Viewport = $Back/Viewport
onready var _transition : ViewportTransition = $ViewportTransition

var _current_scene

func _ready():
	change_scene(load(MAIN_SCENE).instance())
	
func change_scene(scene: Node):
	if _current_scene:
		_play_transition()
		_frontViewport.remove_child(_current_scene)
		_backViewport.add_child(_current_scene)

	if scene.get_parent():
		scene.get_parent().remove_child(scene)
	if scene is Page:
		scene.connect("change_scene",self,"on_change_scene")
	_frontViewport.add_child(scene)
	
	#_backViewport.remove_child(_current_scene)
	_current_scene = scene

func on_change_scene(scene):
	scene.disconnect("change_scene",self,"on_change_scene")
	change_scene(scene)
	
func _play_transition():
	_transition.play(Transition.Type.CURTAIN, 2000, true)
	yield(_transition, "completed")
