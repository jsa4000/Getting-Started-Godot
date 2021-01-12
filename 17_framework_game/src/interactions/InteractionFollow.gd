extends Interaction

export(String) var dialog_player : String = "DialogPlayer"
export(String) var inventory : String = "Inventory"
export(String) var item : String = "Item"

func _execute(actor: Node, entity : Node, parameters : Dictionary, blackboard : Dictionary) -> void:
	var entity_inventory = Types.get_object(entity, Inventory)
	if entity_inventory != null:
		if blackboard[inventory].has(item):
			var inventory_item = blackboard[inventory].get(item)
			entity_inventory.add(inventory_item)
			blackboard[inventory].remove(inventory_item.id)
			blackboard[dialog_player].play("capsule02", "greeting")
			_wait_to_finish(blackboard[dialog_player], "control_closed")
		else:
			blackboard[dialog_player].play("capsule02", "done")
			_wait_to_finish(blackboard[dialog_player], "control_closed")

