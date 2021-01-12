tool
extends Node

var logger : Logger setget ,get_logger
var game_manager : GameManager setget ,get_game_manager
var repository_manager : RepositoryManager setget ,get_repository_manager

func get_logger() -> Logger: return logger
func get_game_manager() -> GameManager: return game_manager
func get_repository_manager() -> RepositoryManager: return repository_manager

func _ready():
	logger = _get_logger()
	logger.debug("Loaded Main logger: %s" % logger.name, self)
	repository_manager = _get_manager_by_type(RepositoryManager)
	logger.debug("Loaded Repository Manager: %s" % repository_manager.name, self)
	game_manager = _get_manager_by_type(GameManager)
	logger.debug("Loaded Game Manager: %s" % game_manager.name, self)

func _get_logger() -> Logger:
	for logger in get_tree().get_nodes_in_group(Logger.GROUP):
		if logger.is_current:
			return logger
	return Logger.new()

func _get_manager_by_type(type: GDScript) -> Node:
	var candidates = []
	for manager in get_tree().get_nodes_in_group(Manager.GROUP):
		if(manager is type && manager.is_current): 
			candidates.append(manager)
	if not candidates.size():
		logger.warn("Manager '%s' has not been found in the tree or not current." % _get_type_name(type), self)
		var manager = type.new()
		get_tree().get_root().add_child(manager)
		candidates.append(manager)
	elif candidates.size() > 1:
		logger.warn("Found more than one candidates of '%s' in the tree." % _get_type_name(type), self)
	return candidates[0]
	
func _get_type_name(type: GDScript) -> String:
	return type.resource_path.get_file().get_basename()
