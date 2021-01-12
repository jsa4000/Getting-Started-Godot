extends Label
class_name StatsPanel

export (bool) var enabled : bool = true setget _set_enabled
export (bool) var fps : bool = true setget _set_fps
export (bool) var draw_calls : bool = true setget _set_draw_calls
export (bool) var static_memory : bool = true setget _set_static_memory
export (bool) var dynamic_memory : bool = true setget _set_dynamic_memory
export (bool) var message_buffer : bool = false setget _set_message_buffer
export (bool) var resources_count : bool = false setget _set_resources_count
export (bool) var objects_count : bool = true setget _set_objects_count

func _ready():
	_set_enabled(enabled)
	_set_fps(fps)
	_set_draw_calls(draw_calls)
	_set_static_memory(static_memory)
	_set_dynamic_memory(dynamic_memory)
	_set_message_buffer(message_buffer)
	_set_resources_count(resources_count)
	_set_objects_count(objects_count)

func _process(_delta: float) -> void:
	_update_stats()
	
func _update_stats() -> void:
	text  = _get_monitor_info()
	
func _get_monitor_info() -> String:
	var stats = PoolStringArray()
	if fps: stats.append("FPS/PROCESS/PHYSICS : %d/%0.2f ms/%0.2f ms" % [Performance.get_monitor(Performance.TIME_FPS),(Performance.get_monitor(Performance.TIME_PROCESS) * 1000),(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000)])
	if draw_calls: stats.append("DRAW CALLS : %d" % Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME))
	if static_memory: stats.append("STATIC MEMORY : %0.2f/%0.2f" % [(Performance.get_monitor(Performance.MEMORY_STATIC) / 1024.0),(Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 1024.0)])
	if dynamic_memory: stats.append("DYNAMIC MEMORY : %0.2f/%0.2f" % [(Performance.get_monitor(Performance.MEMORY_DYNAMIC) / 1024.0),(Performance.get_monitor(Performance.MEMORY_DYNAMIC_MAX) / 1024.0)])	
	if message_buffer: stats.append("MESSAGE BUFFER MEMORY MAX: %0.2f" % (Performance.get_monitor(Performance.MEMORY_MESSAGE_BUFFER_MAX) / 1024.0))	
	if resources_count: stats.append("TOTAL/RESOURCE/NODES: %d/%d/%d" % [Performance.get_monitor(Performance.OBJECT_COUNT),Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT),Performance.get_monitor(Performance.OBJECT_NODE_COUNT)])
	if objects_count: stats.append("OBJECTS/VERTICES: %d/%d" % [Performance.get_monitor(Performance.RENDER_OBJECTS_IN_FRAME), Performance.get_monitor(Performance.RENDER_VERTICES_IN_FRAME)])
	return stats.join("\n")

func _set_enabled(value : bool) -> void:
	enabled = value
	set_process(enabled)
	visible = enabled

func _set_fps(value : bool) -> void:
	fps = value
	_update_stats()

func _set_draw_calls(value : bool) -> void:
	draw_calls = value
	_update_stats()
	
func _set_static_memory(value : bool) -> void:
	static_memory = value
	_update_stats()
	
func _set_dynamic_memory(value : bool) -> void:
	dynamic_memory = value
	_update_stats()
	
func _set_message_buffer(value : bool) -> void:
	message_buffer = value
	_update_stats()
	
func _set_resources_count(value : bool) -> void:
	resources_count = value
	_update_stats()
	
func _set_objects_count(value : bool) -> void:
	objects_count = value
	_update_stats()
