extends BehaviorTreeTaskLeaf

export(String) var emitter : String = "waiting_particles"
export(bool) var emitting : bool = true

func eval(actor : Node, blackboard : Dictionary) -> int:
	var particles : Particles = blackboard[emitter]
	particles.emitting = emitting
	return SUCCESS
