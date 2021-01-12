tool
extends Manager
class_name GameManager

onready var repository_manager : RepositoryManager = ServiceLocator.get_repository_manager() setget ,get_repository_manager

var scene : PackedScene setget set_scene, get_scene

func get_repository_manager() -> RepositoryManager: return repository_manager
func get_scene() -> PackedScene: return scene

func set_scene(value: PackedScene):
	scene = value
	_set_scene(scene)

func _ready():
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		logger.info("Exit Game Application")
		get_tree().quit()

func initialize() -> void:
	pass
	
func save_data() -> void:
	if not repository_manager:
		logger.error("There is no Repository Manager loaded")
		return
	logger.info("Saving Game...", self)
	repository_manager.save_data()
	logger.info("Game Saved", self)
		
func load_data() -> void:
	if not repository_manager:
		logger.error("There is no Repository Manager loaded")
		return
	logger.info("Loading Game...", self)
	repository_manager.load_data()
	logger.info("Game Loadaed", self)

func _set_scene(scene: PackedScene) -> void:
	get_tree().change_scene_to(scene)
