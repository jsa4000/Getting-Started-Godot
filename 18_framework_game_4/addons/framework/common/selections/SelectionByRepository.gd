class_name SelectiondByRepository extends Selection

@export_node_path var repository_path : NodePath
@export_placeholder var key_name : String

var _repository : Repository

func get_object(parent: Node) -> Object:
	if _repository == null:
		_repository = parent.get_node(repository_path)
	var result = _repository.get_value(key_name)
	if result is Array && result.size() == 1:
		result = result[0]
	return result

