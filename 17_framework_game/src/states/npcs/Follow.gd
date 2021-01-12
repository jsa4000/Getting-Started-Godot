extends State

export(String) var target : String = "player"
export(Vector3) var offset : Vector3 = Vector3.ZERO
export(float,0,100,0.1) var distance : float =  0.5
export(float,0.0,5.0,0.1) var move_speed : float = 1.5
export(float,0.0,5.0,0.1) var lookat_speed : float = 0.5

func update(blackboard : Dictionary) -> void:
	var node = blackboard[target]
	
	if (node.global_transform.origin - _actor.global_transform.origin ).length() <= distance:
		return
		
	_actor.global_transform.origin = _actor.global_transform.origin.linear_interpolate(node.global_transform.origin + offset, move_speed * blackboard.delta)
	
	var xform = _actor.global_transform.looking_at(node.global_transform.origin + offset, Vector3.UP)
	_actor.global_transform.basis = _actor.global_transform.basis.slerp(xform.basis, lookat_speed * blackboard.delta)
