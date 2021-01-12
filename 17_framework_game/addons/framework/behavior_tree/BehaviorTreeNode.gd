tool
extends Node
class_name BehaviorTreeNode, "../icons/action.svg"

enum { SUCCESS, FAILURE, RUNNING }

func eval(actor : Node, blackboard : Dictionary) -> int: 
	return FAILURE

func _get_error(message : String) -> String:
	return  "BehaviorTreeNode Error: %s" % message
