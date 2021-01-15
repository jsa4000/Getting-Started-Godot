@tool
extends BehaviorTreeTaskLeaf

@export_placeholder var emitter : String = "particles"
@export var emitting : bool = true

func eval(actor : Node, blackboard : Dictionary) -> int:
	var particles : GPUParticles3D = blackboard[emitter]
	particles.emitting = emitting
	return SUCCESS
