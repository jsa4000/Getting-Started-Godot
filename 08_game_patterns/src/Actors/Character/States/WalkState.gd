tool
extends MotionState
class_name WalkState

export(float,0,1000) var max_speed : float = 300.0
export (float,0,1000) var acceleration : float = 20.0
export (float,0,1) var friction = 0.5
export (float,0,20) var stop_threshold = 0.2

func enter(old_state: State, action: Action, parameters : Dictionary) -> void:
	owner.animated_sprite.play("run")
	if action is MoveAction:
		set_direction(action.direction)
	if parameters && parameters.has("velocity"):
		set_velocity(parameters["velocity"])
			
func update(delta) -> void:
	if direction.x:
		velocity.x += direction.x * acceleration
		if abs(velocity.x) >= max_speed:
			velocity.x = lerp(velocity.x, direction.x * max_speed, friction) 
	else:
		 velocity.x = lerp(velocity.x, 0, friction) 
	.update(delta)

func handle(action : Action) -> void:
	if action is MoveAction:
		match (action.mode):
			MoveAction.Mode.WALK: 
				set_direction(action.direction)
			MoveAction.Mode.RUN:
				emit_signal("state_changed", "RunState", action, {"velocity":velocity})
			MoveAction.Mode.JUMP:
				emit_signal("state_changed", "JumpState", action, {"velocity":velocity})
			_:
				set_direction(Vector2.ZERO)
				_emit_signal_when_completed(action, "IdleState")

func _is_completed() -> bool:
	return abs(velocity.x) < stop_threshold

