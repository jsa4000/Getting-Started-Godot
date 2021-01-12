extends State

export(String) var target : String = "player"
export(float,0.0,5.0,0.1) var move_speed : float = 1.5
export(float,0.0,5.0,0.1) var lookat_speed : float = 0.5

func update(blackboard : Dictionary) -> void:
	var node = blackboard[target]
	
	_actor.global_transform.origin = _actor.global_transform.origin.linear_interpolate(node.global_transform.origin, move_speed * blackboard.delta)
	
	var xform = _actor.global_transform.looking_at(node.global_transform.origin, Vector3.UP)
	_actor.global_transform.basis = _actor.global_transform.basis.slerp(xform.basis, lookat_speed * blackboard.delta)
