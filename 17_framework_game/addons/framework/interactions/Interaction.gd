tool
extends Node
class_name Interaction, "../icons/interaction.svg"

signal interaction_started(interaction)
signal interaction_finished(interaction)

var is_waiting : bool = false

func execute(actor: Node, entity : Node, parameters : Dictionary, blackboard : Dictionary) -> void: 
	emit_signal("interaction_started",self)
	_execute(actor, entity, parameters, blackboard)
	if not is_waiting:
		emit_signal("interaction_finished", self)

func _execute(actor: Node, entity : Node, parameters : Dictionary, blackboard : Dictionary) -> void: 
	pass
		
func _wait_to_finish(object : Object, signal_name : String) -> void:
	is_waiting = true
	yield(object, signal_name)
	is_waiting = false
	emit_signal("interaction_finished", self)
