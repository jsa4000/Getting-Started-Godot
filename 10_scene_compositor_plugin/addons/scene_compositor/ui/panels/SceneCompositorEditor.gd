tool
extends Control
class_name SceneCompositorEditor

const SceneCompositorGraphHeaderScene = preload("res://addons/scene_compositor/ui/panels/SceneCompositorGraphHeader.tscn")

onready var _graph : SceneCompositorGraph = $SceneCompositorGraph
var _header : SceneCompositorGraphHeader

signal graph_updated(graph)
signal node_selected(node)

func _ready():
	_create_header()
	_initialize_list()

func _input(event):
	pass
	#if Input.is_key_pressed(KEY_TAB):
	#	var popup = _list.get_popup()
	#	popup.popup_centered()
	#	popup.rect_position = get_global_mouse_position()
		
func save_data():
	var file = File.new()
	file.open("res://graph.json", File.WRITE)
	file.store_line(to_json(_graph.save_data()))
	file.close()

func load_data():
	var file = File.new()
	if not file.file_exists("res://graph.json"):
		return 
	file.open("res://graph.json", File.READ)
	while file.get_position() < file.get_len():
		_graph.load_data(parse_json(file.get_line()))
	file.close()

func _on_NodeList_item_selected(index):
	_add_node(_header.node_list.get_item_text(index))
	_header.node_list.selected = 0

func _on_run_pressed():
	emit_signal("graph_updated", _graph)

func _on_save_pressed():
	save_data()
	
func _on_load_pressed():
	load_data()
	
func _create_header():
	_header = SceneCompositorGraphHeaderScene.instance()
	_graph.get_zoom_hbox().add_child(_header)	
	_header.node_list.connect("item_selected", self, "_on_NodeList_item_selected" )
	_header.connect("run_pressed", self, "_on_run_pressed")
	_header.connect("save_pressed", self, "_on_save_pressed")
	_header.connect("load_pressed", self, "_on_load_pressed")
	
func _initialize_list():
	_header.node_list.clear()
	_header.node_list.add_item("Nodes",0)
	var nodes =  NodeLoader.new().get_paths().keys()
	for i in range(nodes.size()):
		_header.node_list.add_item(nodes[i],i + 1)
		
func _add_node(type : String):
	return _graph.add_node(type)

func _on_SceneCompositorGraph_node_selected(node):
	emit_signal("node_selected", node)
