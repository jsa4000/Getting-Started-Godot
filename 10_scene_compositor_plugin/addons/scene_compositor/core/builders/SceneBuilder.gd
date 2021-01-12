tool
extends Reference
class_name SceneBuilder

var _scene : Node
var _root : Node
var _graph : SceneCompositorGraph
var _clean : bool

func scene(scene : Node) -> SceneBuilder:
	_scene = scene
	return self
	
func root(root : Node) -> SceneBuilder:
	_root = root
	return self
	
func graph(graph : SceneCompositorGraph) -> SceneBuilder:
	_graph = graph
	return self
	
func clean() -> SceneBuilder:
	_clean = true
	return self

func build() -> Node:
	return _build()

func _build() -> Node:
	if not _scene:
		_scene = _root
	else:
		_root.add_child(_scene)
		_scene.set_owner(_root)
	if _clean:
		_clean(_scene)
	
	for child in _graph.get_children():
		if not child is BaseNode:
			continue
		if child.title == "SceneNode":
			var geometry = _get_data(child._data,  "i_geometry")
			print(geometry)
			for item in geometry:
				_scene.add_child(item)
				item.set_owner(_root)
	
	return _scene

func _get_data(dict: Dictionary, key : String):
	if not dict.has(key):
		return []
	var data = dict[key]
	if not data is Array:
		data = [data]
	return data

func _clean(scene: Node):
	for child in scene.get_children():
		scene.remove_child(child)
		#child.queue_free()
