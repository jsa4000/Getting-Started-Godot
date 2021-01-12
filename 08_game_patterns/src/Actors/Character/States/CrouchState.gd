tool
extends MotionState
class_name CrouchState

export(float,0,1000) var max_speed : float = 200

func enter(old_state: State, action: Action, parameters : Dictionary) -> void:
	owner.animated_sprite.play("crouch")
	if action is MoveAction:
		set_direction(action.direction)

func update(delta) -> void:
	velocity.x = direction.x * max_speed
	.update(delta)

func handle(action : Action) -> void:
	if action is MoveAction:
		match(action.mode):
			MoveAction.Mode.CROUCH:
				set_direction(action.direction)
			MoveAction.Mode.WALK:
				set_direction(action.direction)
			_:
				emit_signal("state_changed", "IdleState", action, null)

