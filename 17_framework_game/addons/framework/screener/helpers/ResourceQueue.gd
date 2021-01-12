extends Reference
class_name ResourceQueue

const MAX_TIME_TO_WAIT = 16000

var _thread : Thread
var _mutex : Mutex
var _sem : Semaphore

var _queue : Array = []
var _pending : Dictionary = {}

func start():
	_mutex = Mutex.new()
	_sem = Semaphore.new()
	_thread = Thread.new()
	_thread.start(self, "_thread_func", 0)

func queue_resource(path : String, p_in_front : bool = false) -> void:
	_lock("queue_resource")
	if path in _pending:
		_unlock("queue_resource")
		return
	elif ResourceLoader.has_cached(path):
		var res = ResourceLoader.load(path)
		_pending[path] = res
		_unlock("queue_resource")
		return
	else:
		var res = ResourceLoader.load_interactive(path)
		res.set_meta("path", path)
		if p_in_front:
			_queue.insert(0, res)
		else:
			_queue.push_back(res)
		_pending[path] = res
		_post("queue_resource")
		_unlock("queue_resource")
		return

func cancel_resource(path : String) -> void:
	_lock("cancel_resource")
	if path in _pending:
		if _pending[path] is ResourceInteractiveLoader:
			_queue.erase(_pending[path])
		_pending.erase(path)
	_unlock("cancel_resource")

func get_progress(path : String) -> float:
	_lock("get_progress")
	var ret : float = -1
	if path in _pending:
		if _pending[path] is ResourceInteractiveLoader:
			ret = float(_pending[path].get_stage()) / float(_pending[path].get_stage_count())
		else:
			ret = 1.0
	_unlock("get_progress")
	return ret

func is_ready(path : String) -> bool:
	var ret : bool
	_lock("is_ready")
	if path in _pending:
		ret = !(_pending[path] is ResourceInteractiveLoader)
	else:
		ret = false
	_unlock("is_ready")
	return ret

func _wait_for_resource(res : Resource, path : String):
	_unlock("wait_for_resource")
	while true:
		VisualServer.sync()
		OS.delay_usec(MAX_TIME_TO_WAIT)
		_lock("wait_for_resource")
		if _queue.size() == 0 || _queue[0] != res:
			return _pending[path]
		_unlock("wait_for_resource")

func get_resource(path : String) -> Resource:
	_lock("get_resource")
	if path in _pending:
		if _pending[path] is ResourceInteractiveLoader:
			var res = _pending[path]
			if res != _queue[0]:
				var pos = _queue.find(res)
				_queue.remove(pos)
				_queue.insert(0, res)
			res = _wait_for_resource(res, path)
			_pending.erase(path)
			_unlock("return")
			return res
		else:
			var res = _pending[path]
			_pending.erase(path)
			_unlock("return")
			return res
	else:
		_unlock("return")
		return ResourceLoader.load(path)

func _thread_process() -> void:
	_wait("thread_process")
	_lock("process")
	while _queue.size() > 0:
		var res = _queue[0]
		_unlock("process_poll")
		var ret = res.poll()
		_lock("process_check_queue")
		if ret == ERR_FILE_EOF || ret != OK:
			var path = res.get_meta("path")
			if path in _pending:
				_pending[res.get_meta("path")] = res.get_resource()
			_queue.erase(res)
	_unlock("process")

func _thread_func(_u) -> void:
	while true:
		_thread_process()
	
func _lock(_caller) -> void:
	_mutex.lock()

func _unlock(_caller) -> void:
	_mutex.unlock()

func _post(_caller) -> void:
	_sem.post()

func _wait(_caller) -> void:
	_sem.wait()
