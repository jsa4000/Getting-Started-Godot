@tool
extends BehaviorTreeTaskLeaf

@export_placeholder var elapsed : String = "elapsed"
@export var milliseconds : int = 5000

var _start_time = 0

func eval(actor : Node, blackboard : Dictionary) -> int:
	if not blackboard.has(elapsed):
		_start_time = OS.get_ticks_msec()
		blackboard[elapsed] = 0
		return RUNNING
	blackboard[elapsed] = OS.get_ticks_msec() -_start_time
	if blackboard[elapsed] <= milliseconds:
		return RUNNING
	blackboard.erase(elapsed)
	return SUCCESS
