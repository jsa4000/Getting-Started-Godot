class_name CollectionUtils

static func merge_dicts(dict1 : Dictionary, dict2 : Dictionary) -> Dictionary:
	var dict = {}
	for key in dict1:
		dict[key] = dict1[key]
	for key in dict2:
		dict[key] = dict2[key]
	return dict
	

