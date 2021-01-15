class_name SceneDelegate extends Resource

signal on_load_scene(name, show_loading)

func load_scene(path : String, show_loading : bool = false) -> void:
	on_load_scene.emit(path, show_loading)
