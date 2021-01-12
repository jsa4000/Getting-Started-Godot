extends Resource
class_name SelectionUtils

static func get_data_from_node(node: Node, data : Dictionary) -> Dictionary:
	var result = {}
	for key in data:
		if data[key] is Selection:
			result[key] = data[key].get_object(node)
		elif data[key] is NodePath:
			result[key] = node.get_node(data[key])
			assert(result[key] != null, "Selection Error: No node has been found in path %s" % data[key])
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
