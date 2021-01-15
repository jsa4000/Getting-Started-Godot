@tool
class_name BehaviorTreeLimiterDecorator extends BehaviorTreeDecorator
@icon("../../icons/limiter.svg")

@export var max_count : float = 0

@onready var _cache_key = 'limiter_%s' % get_instance_id()

func eval(actor : Node, blackboard : Dictionary) -> int:
	var current_count = blackboard[_cache_key]

	if current_count == null:
		current_count = 0

	if current_count <= max_count:
		blackboard[_cache_key] = current_count + 1
		return get_child(0).eval(actor, blackboard)
	else:
		return FAILED
