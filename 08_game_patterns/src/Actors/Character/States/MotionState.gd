tool
extends State
class_name MotionState

export (float,0,1000) var gravity = 500.0

var direction : Vector2  = Vector2.ZERO setget set_direction
var velocity : Vector2 = Vector2.ZERO setget set_velocity

var _waiting_action : Action = null

func set_velocity(value : Vector2) -> void:
	velocity = value
	
func set_direction(value: Vector2) -> void:
	direction = value.normalized()
	if direction.x < 0:
		owner.animated_sprite.flip_h = true
	elif direction.x > 0:
		owner.animated_sprite.flip_h = false

func update(delta) -> void:	
	_apply_motion(delta)
	_check_waiting_action()
	
func exit(new_state : State, action: Action, parameters : Dictionary) -> void:
	set_direction(Vector2.ZERO)
	set_velocity(Vector2.ZERO)

func _apply_motion(delta : float) -> void:
	velocity.y += gravity * delta
	velocity = owner.move_and_slide(velocity, Vector2.UP)
	
func _emit_signal_when_completed(action : Action, new_state : String):
	if _is_completed():
		emit_signal("state_changed", new_state, action, null)
		_waiting_action = null
	else	:
		_waiting_action = action

func _is_completed() -> bool:
	return true
	
func _check_waiting_action():
	if _waiting_action:
		handle(_waiting_action)	
