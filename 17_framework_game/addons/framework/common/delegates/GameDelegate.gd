extends Resource
class_name GameDelegate

enum Mode {INTRO, MENU, NEW, LOAD, CUSTOM }

signal change_mode(mode, param)

signal pause(node)
signal resume(node)

signal save_data()
signal load_data()

signal exit()

func change_mode(mode : int, params : Dictionary = {}) -> void:
	emit_signal("change_mode", mode, params)

func pause(node : Node) -> void:
	emit_signal("pause", node)

func resume(node : Node) -> void:
	emit_signal("resume", node)

func save_data() -> void:
	emit_signal("save_data")

func load_data() -> void:
	emit_signal("load_data")
	
func exit() -> void:
	emit_signal("exit")
