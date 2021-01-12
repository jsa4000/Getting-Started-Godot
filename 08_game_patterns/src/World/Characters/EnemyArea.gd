extends Area2D

func _ready():
	pass

var actors : Array

func _on_Area2D_body_entered(body):
	var actors = TreeUtil.get_nodes_in_group(body, Actor.GROUP)
	if actors.empty():
		return
	print("Entered %s" % actors[0].alias)
	actors.append(actors[0])
	

func _on_Area2D_body_exited(body):
	var actors = TreeUtil.get_nodes_in_group(body, Actor.GROUP)
	if actors.empty():
		return
	print("Exited %s" % actors[0].alias)
	actors.erase(actors[0])
