extends Resource
class_name Selection

func get_object(parent: Node) -> Object: return null

func _get_error(message : String) -> String:
	return  "Selection Error: %s" % message

