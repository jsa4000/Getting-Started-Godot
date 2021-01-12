extends SceneLoader
class_name Screener, "../icons/screener.svg"

export(PackedScene) var loading_scene : PackedScene
export(Resource) var scene_delegate : Resource

onready var back_viewport : Viewport = $BackViewport/Viewport
onready var front_viewport : Viewport = $FrontViewport/Viewport
onready var transition : ViewportTransition = $ViewportTransition

var _resource_queue : ResourceQueue
var _is_in_transition : bool = false

var _scene_path : String

func _init():
	add_to_group(ScreenerGlobal.SCREENER_GROUP)

func _ready():
	_init_resource_queue()
	_init_scene_delegate()
	set_process(false)

func _init_resource_queue():
	_resource_queue = ResourceQueue.new()
	_resource_queue.start()
	
func _init_scene_delegate():
	if scene_delegate == null:
		return
	scene_delegate.connect("load_scene", self, "_on_load_scene")

func _on_load_scene(path : String, show_loading : bool) -> void:
	load_scene(path,show_loading)
	
func load_scene(path : String, show_loading : bool = false) -> void:
	_scene_path = path
	_resource_queue.queue_resource(path)
	if show_loading:
		_change_scene(loading_scene)
	set_process(true)

func _process(delta):
	if _resource_queue.is_ready(_scene_path) && not _is_in_transition:
		set_process(false)
		_change_scene(_resource_queue.get_resource(_scene_path))
		
func _change_scene(scene : PackedScene, fade_out : bool = false) -> void:	
	transition.reset()
	_is_in_transition = true
	_clear_viewport(back_viewport, true)
	
	var current_scene = scene.instance()
	back_viewport.add_child(current_scene)
	
	transition.play()	
	yield(transition, "all_completed")
	
	_clear_viewport(front_viewport, true)
	_clear_viewport(back_viewport, false)
	
	front_viewport.add_child(current_scene)
	transition.reset()
	emit_signal("scene_loaded",current_scene)
	_is_in_transition = false
	
func _clear_viewport(viewport : Node, free : bool = true) -> void:
	for child in viewport.get_children():
		viewport.remove_child(child)
		if free:
			child.queue_free()
