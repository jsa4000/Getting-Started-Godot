extends Interaction

@export_placeholder var particles : String = "particles"

func _execute(actor: Node, entity : Node, parameters : Dictionary, blackboard : Dictionary) -> void: 
	blackboard[particles].emitting = true
