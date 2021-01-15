@tool
extends BehaviorTreeTaskLeaf

@export_placeholder var points : String = "points"
@export_placeholder var destination : String = "destination"

var _points : Array = []
var _current_position : int = -1

func eval(actor : Node, blackboard : Dictionary) -> int:
	if _points.is_empty():
		_points = blackboard[points].get_children()
	
	if _current_position == -1 || _points.size() == _current_position + 1:
		_current_position = 0
	else:
		_current_position += 1
	blackboard[destination] = _points[_current_position]
	return SUCCESS
