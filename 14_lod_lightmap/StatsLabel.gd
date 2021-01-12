extends Label

func _process(_delta: float) -> void:
	var stats = PoolStringArray()
	stats.append("FPS : %d" % Performance.get_monitor(Performance.TIME_FPS))
	stats.append("PROCESS : %f ms" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000))
	stats.append("PHYSICS : %f ms" % (Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000))
	stats.append("STATIC MEMORY : %0.2f" % (Performance.get_monitor(Performance.MEMORY_STATIC) / 1024.0))
	stats.append("DYNAMIC MEMORY : %0.2f" % (Performance.get_monitor(Performance.MEMORY_DYNAMIC) / 1024.0))
	stats.append("STATIC MEMORY MAX : %0.2f" % (Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 1024.0))
	stats.append("DYNAMIC MEMORY MAX: %0.2f" % (Performance.get_monitor(Performance.MEMORY_DYNAMIC_MAX) / 1024.0))	
	stats.append("MESSAGE BUFFER MEMORY MAX: %0.2f" % (Performance.get_monitor(Performance.MEMORY_MESSAGE_BUFFER_MAX) / 1024.0))	
	stats.append("OBJECT COUNT: %d" % Performance.get_monitor(Performance.OBJECT_COUNT))
	stats.append("OBJECT RESOURCE COUNT: %d" % Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT))
	stats.append("OBJECT NODE COUNT: %d" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	stats.append("3D OBJECTS COUNT: %d" % Performance.get_monitor(Performance.RENDER_OBJECTS_IN_FRAME))
	stats.append("3d VERTICES COUNT: %d" % Performance.get_monitor(Performance.RENDER_VERTICES_IN_FRAME))
		
	text = stats.join("\n")
