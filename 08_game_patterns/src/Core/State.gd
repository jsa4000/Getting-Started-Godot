tool
extends Node
class_name State

const GROUP : String = "states"

onready var logger : Logger = ServiceLocator.get_logger()

signal state_changed(next_state, action, parameters)

func _init():
	add_to_group(GROUP)

func enter(old_state: State, action: Action, parameters : Dictionary) -> void:
	pass

func update(delta) -> void:
	pass

func exit(new_state : State, action: Action, parameters : Dictionary) -> void:
	pass

func handle(action : Action) -> void:
	pass
