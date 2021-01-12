extends BehaviorTreeConditionLeaf

export(String) var inventory : String = "Inventory"
export(String) var item : String = "Item"

func eval(actor : Node, blackboard : Dictionary) -> int:
	if blackboard[inventory].has(item):
		return SUCCESS
	return FAILURE
