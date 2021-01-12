tool
extends EditorScript
class_name CreatePage

func _run():
	get_scene().name = "page"
	var new_node = Node.new() 
	new_node.name = "NewNode"
	get_scene().add_child(new_node)
	new_node.set_owner(get_scene())


