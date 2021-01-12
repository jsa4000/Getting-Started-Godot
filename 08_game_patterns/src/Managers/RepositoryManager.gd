tool
extends Manager
class_name RepositoryManager

func save_data():
	logger.error("Error. Method not implemented", self)
	
func load_data():
	logger.error("Error. Method not implemented", self)

func _get_repositories() -> Array:
	var repositories = Array()
	for repository in get_tree().get_nodes_in_group(Repository.GROUP):
		repositories.append(repository)
	return repositories
