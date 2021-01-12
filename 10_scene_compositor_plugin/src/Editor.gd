extends Spatial

func _ready():
	pass

onready var scene = $VSplit/HSplit/SceneCompositorViewport/Viewport/SceneCompositor
onready var properties = $VSplit/HSplit/SceneCompositorProperties

func _on_SceneCompositorEditor_graph_updated(graph):
	SceneBuilder.new().root(self).scene(scene).graph(graph).clean().build()
	
func _on_SceneCompositorEditor_node_selected(node):
	properties.set_node(node)
