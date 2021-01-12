extends Game
class_name GameManager, "../icons/game.svg"

export(NodePath) var scene_loader : NodePath
export(Resource) var game_delegate : Resource

onready var _scene_loader = get_node(scene_loader)

func _init():
	add_to_group(GameGlobal.GAME_GROUP)

func _ready():
	_init_game_delegate()
	change_mode(GameDelegate.Mode.INTRO)
	
func _init_game_delegate():
	if game_delegate ==  null:
		return
	game_delegate.connect("change_mode", self, "_on_change_mode")
	game_delegate.connect("pause", self, "_on_pause")
	game_delegate.connect("resume", self, "_on_resume")
	game_delegate.connect("save_data", self, "_on_save_data")
	game_delegate.connect("load_data", self, "_on_load_data")
	game_delegate.connect("exit", self, "_on_exit")

func change_mode(mode : int, params : Dictionary = {}) -> void:
	_pre_change_mode(mode,params)
	if mode != GameDelegate.Mode.CUSTOM:
		var scene = _get_scenes()[mode]
		_scene_loader.load_scene(scene.path, scene.loading)
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
