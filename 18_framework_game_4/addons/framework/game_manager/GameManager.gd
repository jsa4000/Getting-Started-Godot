@tool
class_name GameManager extends Game
@icon("../icons/game.svg")

@export_node_path var scene_loader : NodePath
@export var game_delegate : Resource

# TODO: Godot 4.0 crashes waiting for the node from NodePath in tool mode
#@onready var _scene_loader : SceneLoader = get_node(scene_loader)
var _scene_loader : SceneLoader

func _init():
	add_to_group(GameGlobal.GAME_GROUP)

func _ready():
	# TODO: Load the _scene_loader from here checking is not in the editor
	if Engine.is_editor_hint():
		return
	_set_scene_loader(scene_loader)
	_init_game_delegate()
	change_mode(GameDelegate.Mode.INTRO)

func _init_game_delegate():
	if game_delegate ==  null:
		return
	game_delegate.on_change_mode.connect(_on_change_mode)
	game_delegate.on_pause.connect(_on_pause)
	game_delegate.on_resume.connect(_on_resume)
	game_delegate.on_save_data.connect(_on_save_data)
	game_delegate.on_load_data.connect(_on_load_data)
	game_delegate.on_exit.connect(_on_exit)

func change_mode(mode : int, params : Dictionary = {}) -> void:
	_pre_change_mode(mode,params)
	if mode != int(GameDelegate.Mode.CUSTOM):
		var scene = _get_scenes()[mode]
		# TODO: Godot 4.0 do not recognize indexes by members
		#_scene_loader.load_scene(scene.path, scene.loading)
		_scene_loader.load_scene(scene.get("path"), scene.get("loading"))
	else:
		_custom_mode(params)
	_post_change_mode(mode,params)
		
func pause(node : Node) -> void:
	get_tree().paused = true

func resume(node : Node) -> void:
	get_tree().paused = false

func save_data() -> void: pass

func load_data() -> void: pass
	
func exit() -> void:
	get_tree().quit()

func _get_scenes() -> Dictionary: return {}

func _pre_change_mode(mode : int, params : Dictionary = {}) -> void: pass

func _post_change_mode(mode : int, params : Dictionary = {}) -> void: pass

func _custom_mode(params : Dictionary ) -> void: pass

func _on_change_mode(mode : int, params : Dictionary) -> void:
	change_mode(mode, params)

func _on_pause(node : Node) -> void:
	pause(node)

func _on_resume(node : Node) -> void:
	resume(node)

func _on_save_data() -> void:
	save_data() 

func _on_load_data() -> void:
	load_data()
	
func _on_exit() -> void:
	exit()

func _set_scene_loader(value: NodePath):
	if not value.is_empty():
		_scene_loader = get_node(value)
