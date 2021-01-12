extends Interaction

export(String) var dialog_player : String = "DialogPlayer"
export(String) var inventory : String = "Inventory"
export(String) var parameter : String = "item"
export(String) var item : String = "Item"

func _execute(actor: Node, entity : Node, parameters : Dictionary, blackboard : Dictionary) -> void: 
	if not blackboard[inventory].has(item):	
		if not (parameters.has(parameter) && parameters[parameter].id == item):
			blackboard[dialog_player].play("capsule01", "needful")
			_wait_to_finish(blackboard[dialog_player], "control_closed")
		else:
			blackboard[inventory].add(parameters[parameter])
			var entity_inventory = Types.get_object(entity, Inventory)
			if entity_inventory != null:
				entity_inventory.remove(parameters[parameter].id)
			blackboard[dialog_player].play("capsule01", "greeting")
			_wait_to_finish(blackboard[dialog_player], "control_closed")
	else:
		blackboard[dialog_player].play("capsule01", "done")
		_wait_to_finish(blackboard[dialog_player], "control_closed")
