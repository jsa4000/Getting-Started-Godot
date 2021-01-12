extends Loader
class_name NodeLoader

const SceneNodesPath : String = "res://addons/scene_compositor/nodes/scenes/"
const SceneNodesExtensions : Array = ["tscn"]

const ScriptNodesPath : String = "res://addons/scene_compositor/nodes/scripts/"
const ScriptNodesExtensions : Array = ["gd"]

func get_resources() -> Dictionary:
	var scene_nodes = FileUtils.load_files_from_path(SceneNodesPath, SceneNodesExtensions)
	var script_nodes = FileUtils.load_files_from_path(ScriptNodesPath, ScriptNodesExtensions)
	return CollectionUtils.merge_dicts(scene_nodes, script_nodes)

func get_paths() -> Dictionary:
	var scene_nodes = FileUtils.get_files_from_path(SceneNodesPath, SceneNodesExtensions)
	var script_nodes = FileUtils.get_files_from_path(ScriptNodesPath, ScriptNodesExtensions)
	return CollectionUtils.merge_dicts(scene_nodes, script_nodes)
