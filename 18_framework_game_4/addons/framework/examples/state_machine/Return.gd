extends State

const DELTA = "delta"

@export_placeholder var target : String = "start_position"
@export_range(0.0,5.0,0.1) var move_speed : float = 1.5
@export_range(0.0,5.0,0.1) var lookat_speed : float = 0.5

func update(blackboard : Dictionary) -> void:
	var node = blackboard[target]
	
	# TODO: In Godot 4..0 is not allowed access to its members using 'dict.key'
	_actor.global_transform.origin = _actor.global_transform.origin.lerp(node.global_transform.origin, move_speed * blackboard[DELTA])
	
	var xform = _actor.global_transform.looking_at(node.global_transform.origin, Vector3.UP)
	_actor.global_transform.basis = _actor.global_transform.basis.slerp(xform.basis, lookat_speed * blackboard[DELTA])
