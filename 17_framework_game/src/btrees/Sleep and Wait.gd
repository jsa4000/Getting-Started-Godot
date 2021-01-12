extends BehaviorTreeTaskLeaf

export(String) var elapsed : String = "elapsed"
export(int) var milliseconds : int = 5000

var _start_time = 0

func eval(actor : Node, blackboard : Dictionary) -> int:
	if not blackboard.has(elapsed):
		_start_time = OS.get_system_time_msecs()
		blackboard[elapsed] = 0
		return RUNNING
	blackboard[elapsed] = OS.get_system_time_msecs() -_start_time
	if blackboard[elapsed] <= milliseconds:
		return RUNNING
	blackboard.erase(elapsed)
	return SUCCESS
