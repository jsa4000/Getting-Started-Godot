extends BehaviorTreeTaskLeaf

export(String) var target : String = "player"
export(Vector3) var offset : Vector3 = Vector3.ZERO
export(float,0.0,5.0,0.1) var speed : float = 1.5
export(bool) var wait : bool = false

func eval(actor : Node, blackboard : Dictionary) -> int:
	var node = blackboard[target]
	
	var xform = actor.global_transform.looking_at(node.global_transform.origin + offset, Vector3.UP)
	actor.global_transform.basis = actor.global_transform.basis.slerp(xform.basis, speed * blackboard.delta)

	if wait && not _is_looking_at(actor, node):
		return RUNNING
	else:
		return SUCCESS

func _is_looking_at(actor: Spatial, target: Spatial) -> bool:
	var  direction = ((target.global_transform.origin + offset) - actor.global_transform.origin).normalized()
	return abs(direction.dot(actor.global_transform.basis.z)) > 0.95
