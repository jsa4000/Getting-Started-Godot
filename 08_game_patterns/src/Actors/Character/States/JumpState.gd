tool
extends MotionState
class_name JumpState

export (float,0,1000) var jump_speed = 400

func enter(old_state: State, action: Action, parameters : Dictionary) -> void:
	owner.animated_sprite.play("jump")
	if action is MoveAction:
		direction = action.direction
	if parameters && parameters.has("velocity"):
		set_velocity(parameters["velocity"])

func update(delta) -> void:
	if owner.is_on_floor() || velocity.y == 0.0: # Sometimes 'is_on_floor' does not work
		velocity.y = -jump_speed
	else:
		if velocity.y > 0:
			owner.animated_sprite.play("fall")
		elif velocity.y < 0:
			owner.animated_sprite.play("jump")
	.update(delta)
	
func handle(action : Action) -> void:
	if action is MoveAction:
		match (action.mode):
			MoveAction.Mode.JUMP:
				return
			_:
				_emit_signal_when_completed(action, "IdleState")

func _is_completed() -> bool:
	return owner.is_on_floor()
