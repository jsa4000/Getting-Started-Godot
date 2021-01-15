class_name SelectionUtils

static func get_data_from_node(node: Node, data : Dictionary) -> Dictionary:
	var result = {}
	for key in data:
		if data[key] is Selection:
			result[key] = data[key].get_object(node)
		# TODO: Godot 4 Workaround instead using 'data[key] is NodePath'
		elif typeof(data[key]) == TYPE_NODE_PATH:
			result[key] = node.get_node(data[key])
		else:
			result[key] = data[key]
	return result

static func join(dict1: Dictionary, dict2 : Dictionary) -> Dictionary:
	var result = {}
	for key in dict1:
		result[key] = dict1[key]
	for key in dict2:
		result[key] = dict2[key]
	return result
