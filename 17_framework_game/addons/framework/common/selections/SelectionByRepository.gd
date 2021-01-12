extends Selection
class_name SelectiondByRepository

export(NodePath) var repository_path : NodePath
export(String) var key_name : String

var _repository : Repository

func get_object(parent: Node) -> Object:
	if _repository == null:
		_repository = parent.get_node(repository_path)
		assert(_repository != null, _get_error("Repository %s noot found" % repository_path))
	assert(key_name != null, _get_error("A key name must be provided"))
	var result = _repository.get(key_name)
	assert(result != null, _get_error("No occurrences has been found for key %s" % key_name))
	if result is Array && result.size() == 1:
		result= result[0]
	return result

