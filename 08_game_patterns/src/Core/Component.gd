tool
extends Node
class_name Component

const GROUP : String = "components"

export(String) var _component_group : String = "" setget , get_component_group
export(String) var _component_name : String = "" setget , get_component_name

onready var logger : Logger = ServiceLocator.get_logger()

func get_component_name() -> String: return _component_name
func get_component_group() -> String: return _component_group
	
func _init():
	add_to_group(GROUP)

func _get_nodes_in_group(group: String) -> Dictionary:
	var nodes = Dictionary()
	for node in TreeUtil.get_nodes_in_group(self, group):
		nodes[node.name] = node
	return nodes

func to_string() -> String:
	return get_component_name()

func to_dictionary() -> Dictionary:
	return {} 
