@tool
class_name Interaction extends Node
@icon("../icons/interaction.svg")

signal interaction_started(interaction)
signal interaction_finished(interaction)

var is_waiting : bool = false

func execute(actor: Node, entity : Node, parameters : Dictionary, blackboard : Dictionary) -> void: 
	interaction_started.emit(self)
	_execute(actor, entity, parameters, blackboard)
	if not is_waiting:
		interaction_finished.emit(self)

func _execute(actor: Node, entity : Node, parameters : Dictionary, blackboard : Dictionary) -> void: 
	pass
		
func _wait_to_finish(object : Object, callable : Callable) -> void:
	is_waiting = true
	# TODO: JSA4000 To see how can be made iin Godot 4 using await an callable
	await callable
	is_waiting = false 
	interaction_finished.emit(self)
