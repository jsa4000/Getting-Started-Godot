extends Node

func get_children_by_type(node: Node, type: GDScript) -> Array:
	var list = []
	for child in node.get_children():
		if(child is type): 
			list.append(child )
	return list
