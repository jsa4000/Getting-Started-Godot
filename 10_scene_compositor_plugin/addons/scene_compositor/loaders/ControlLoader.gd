extends Loader
class_name ControlLoader

const ControlsPath : String = "res://addons/scene_compositor/ui/controls/"
const ControlsExtensions : Array = ["tscn"]

func get_resources() -> Dictionary:
	return FileUtils.load_files_from_path(ControlsPath, ControlsExtensions)

func get_paths() -> Dictionary:
	return FileUtils.get_files_from_path(ControlsPath, ControlsExtensions)
