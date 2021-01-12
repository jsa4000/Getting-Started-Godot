tool
extends RepositoryManager
class_name RepositoryFileManager

func save_data() -> void:	
	var repositories = _get_repositories()
	for repository in repositories:
		logger.debug(repository.actor)
	
func load_data() -> void:
	var repositories = _get_repositories()
	for repository in repositories:
		logger.debug(repository.actor)
