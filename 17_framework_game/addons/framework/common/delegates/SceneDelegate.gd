extends Resource
class_name SceneDelegate

signal load_scene(name, show_loading)

func load_scene(path : String, show_loading : bool = false) -> void:
	emit_signal("load_scene", path, show_loading)
