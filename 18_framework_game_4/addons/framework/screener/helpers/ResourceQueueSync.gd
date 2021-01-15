@tool
class_name ResourceQueueSync extends Reference

var _pending : Dictionary = {}

# TODO: Godot 4.0 has removed ResourceInteractiveLoader for a threaded approach
func start():
	pass

func queue_resource(path : String) -> void:
	_pending[path] = ResourceLoader.load(path)

func cancel_resource(path : String) -> void:
	if path in _pending:
		_pending.erase(path)

func is_ready(path : String) -> bool:
	if path in _pending:
		return true
	return false

func get_resource(path : String) -> Resource:
	if path in _pending:
		var res = _pending[path]
		_pending.erase(path)
		return res
	else:
		return ResourceLoader.load(path)

