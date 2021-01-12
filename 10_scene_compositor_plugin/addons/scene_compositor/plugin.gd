tool
extends EditorPlugin

const SceneCompositor = preload("core/types/SceneCompositor.gd")
const SceneCompositorEditor = preload("ui/panels/SceneCompositorEditor.tscn")
const MainIconSmall = preload("assets/icons/main_icon_small.png")

var _editor

func _enter_tree():
	_editor = SceneCompositorEditor.instance()
	add_control_to_bottom_panel(_editor, "Scene Compositor")
	_editor.connect("graph_updated", self, "_on_graph_updated")
	add_custom_type("SceneCompositor", "Spatial", SceneCompositor, MainIconSmall)

func _exit_tree():
	remove_custom_type("SceneCompositor")
	if _editor:
		_editor.disconnect("graph_updated", self, "_on_graph_updated")
		remove_control_from_bottom_panel(_editor)
		_editor.free()

func get_plugin_icon() -> Texture:
	return MainIconSmall

func handles(object):
	return object is SceneCompositor

func make_visible(visible):
	if _editor:
		_editor.set_visible(visible)

func forward_input_event(event):
	return true

func _on_graph_updated(graph):
	var root_scene = get_editor_interface().get_edited_scene_root()
	var selected_nodes = get_editor_interface().get_selection().get_selected_nodes()
	if not (selected_nodes.size() == 1 && selected_nodes[0] is SceneCompositor):
		return

	SceneBuilder.new().root(root_scene).scene(selected_nodes[0]).graph(graph).clean().build()



