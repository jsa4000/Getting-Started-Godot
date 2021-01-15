@tool
extends BehaviorTreeConditionLeaf

@export_placeholder var inventory : String = "Inventory"
@export_placeholder var item : String = "Item"

func eval(actor : Node, blackboard : Dictionary) -> int:
	if blackboard[inventory].has(item):
		return SUCCESS
	return FAILURE
