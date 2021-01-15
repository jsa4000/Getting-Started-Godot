@tool
class_name BehaviorTreeNode extends Node
@icon("../icons/action.svg")

enum { SUCCESS, FAILURE, RUNNING }

func eval(actor : Node, blackboard : Dictionary) -> int: 
	return FAILURE
