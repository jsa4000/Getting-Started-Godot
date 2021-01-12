tool
extends AreaDirectional
class_name AreaInteractive

var candidates = Array()

signal interaction_requested(actor)
		
func _ready():
	connect("actor_entered", self, "_on_actor_entered")
	connect("actor_exited", self, "_on_actor_exited")

func _on_actor_entered(actor):
	actor.connect("interaction_requested", self, "_on_interaction_requested")
	candidates.append(actor)
	
func _on_actor_exited(actor):
	actor.disconnect("interaction_requested", self, "_on_interaction_requested")
	candidates.erase(actor)

func _on_interaction_requested(actor):
	emit_signal("interaction_requested", actor)
