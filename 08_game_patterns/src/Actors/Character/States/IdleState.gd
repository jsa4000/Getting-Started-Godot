tool
extends MotionState
class_name IdleState

func enter(old_state: State, action: Action, parameters : Dictionary) -> void:
	owner.animated_sprite.play("idle")

func handle(action : Action) -> void:
	if action is MoveAction:
		match(action.mode):
			MoveAction.Mode.WALK:
				emit_signal("state_changed", "WalkState", action, null)
			MoveAction.Mode.CROUCH:
				emit_signal("state_changed", "CrouchState", action, null)
			MoveAction.Mode.JUMP:	
				emit_signal("state_changed", "JumpState", action, null)

