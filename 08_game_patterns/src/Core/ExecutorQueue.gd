tool
extends Executor
class_name ExecutorQueue

export(bool) var is_deferred_enabled : bool = false

var _queue : Array = Array()
var _is_executing = false

func _process(delta):
	if not is_deferred_enabled:
		return
	_execute_deferred()
	
func execute() -> void:
	if is_deferred_enabled:
		return
	_execute()
	
func size() -> int:
	return _queue.size()

func next() -> Action:
	if _queue.empty():
		return null
	return _queue.pop_front()
	
func add(action: Action) -> void:
	_queue.push_back(action)

func _execute() -> void:
	var action := next()
	action.connect("finished", self, "_on_finished")
	action.execute()
	
func _execute_deferred() -> void:
	if _queue.empty() || _is_executing:
		return
	_is_executing = true
	_execute()

func _on_finished(action, error):
	action.disconnect("finished", self, "_on_finished")
	emit_signal("action_finished", action, error)
	_is_executing = false
	
