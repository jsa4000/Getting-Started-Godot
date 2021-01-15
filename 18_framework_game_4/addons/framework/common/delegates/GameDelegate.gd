class_name GameDelegate extends Resource

enum Mode {INTRO, MENU, NEW, LOAD, CUSTOM }

signal on_change_mode(mode, param)

signal on_pause(node)
signal on_resume(node)

signal on_save_data()
signal on_load_data()

signal on_exit()

func change_mode(mode : int, params : Dictionary = {}) -> void:
	on_change_mode.emit(mode, params)

func pause(node : Node) -> void:
	on_pause.emit(node)

func resume(node : Node) -> void:
	on_resume.emit(node)

func save_data() -> void:
	on_save_data.emit()

func load_data() -> void:
	on_load_data.emit()
	
func exit() -> void:
	on_exit.emit()
