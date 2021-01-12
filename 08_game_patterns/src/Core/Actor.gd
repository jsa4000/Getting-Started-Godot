tool
extends Node
class_name Actor

const GROUP := "actors"

export(String) var id: String = UUID.v4()
export(String) var alias: String

onready var logger : Logger = ServiceLocator.get_logger()

var _components : Dictionary = Dictionary() setget , get_components

func get_components(): return _components

func get_component(name: String) -> Component: 
	if not _components.has(name):
		logger.error("Component %s has not been founf on actor %s" % [name, id])
		return null;
	return _components[name]

func _init():
	add_to_group(GROUP)
	
func _ready():
	_initialize_components()
	logger.debug(to_string(), self)
			
func _initialize_components():
	_components = _get_components_in_group(Component.GROUP)
		
func _get_components_in_group(group: String) -> Dictionary:
	var nodes = Dictionary()
	for node in TreeUtil.get_nodes_in_group(self, group):
		nodes[node.get_component_name()] = node
	return nodes
				
func to_string():
	var string = PoolStringArray()
	string.append("Actor")
	string.append("{")
	var content = PoolStringArray()
	content.append("id: %s" % id)
	content.append("alias: %s" % alias)
	for key in _components:
		content.append(_components[key].to_string())
	string.append(content.join(", "))
	string.append("}")
	return string.join(" ")
