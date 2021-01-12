tool
extends Area
class_name AreaDirectional

export(Vector3) var direction = Vector3.ZERO setget set_direction
export(float,0,360) var threshold_degrees = 60
export(bool) var disabled = false setget set_disabled
export(Color, RGBA) var arrow_modulate = Color.white

onready var guide = $Guides
onready var collision = $Collision
onready var arrows : Array = [$Guides/ArrowH, $Guides/ArrowV, $Guides/ArrowAll]

var current_arrow

signal actor_entered(actor)
signal actor_exited(actor)

func set_disabled(newVal): 
	disabled = newVal
	_disable_collision(disabled)

func set_direction(newVal):
	direction = newVal
	_set_guide_direction()
	
func _ready():
	_initialize()
		
func _initialize():
	_disable_collision(disabled)
	_set_guide_direction()
	if not disabled:
		connect("body_entered",self,"_on_body_entered")
		connect("body_exited",self,"_on_body_exited")
	
func _set_guide_direction():
	if not guide:
		return
	for arrow in arrows:
		arrow.hide()
	if direction == Vector3.ZERO:
		current_arrow = arrows[2]
	elif direction + guide.global_transform.origin != guide.global_transform.origin:
		if not direction.y:
			guide.look_at(direction + guide.global_transform.origin,Vector3.UP)
			current_arrow = arrows[0]
		else:
			guide.look_at(direction + guide.global_transform.origin,Vector3.RIGHT)
			current_arrow = arrows[1]
	current_arrow.modulate = arrow_modulate
	current_arrow.show()

func _on_body_exited(body):
	if not body is Actor:
		return
	emit_signal("actor_exited", body)

func _on_body_entered(body):
	if not body is Actor:
		return
	if direction == Vector3.ZERO ||_get_angle(direction, body.direction()) <= threshold_degrees:
		emit_signal("actor_entered", body)
	else:
		_play_bad_direction_animation()

func _get_angle(start, end) -> float:
	return rad2deg(start.normalized().angle_to(end.normalized()))

func _show(enabled):
	if enabled: show() 
	else: hide()
	
func _disable_collision(disabled):
	if collision:
		collision.disabled = disabled
	_show(!disabled)

func _play_bad_direction_animation():
	current_arrow.modulate = Color.red
	yield(get_tree().create_timer(.3),"timeout")
	current_arrow.modulate = arrow_modulate
	yield(get_tree().create_timer(.3),"timeout")
	current_arrow.modulate = Color.red
	yield(get_tree().create_timer(.3),"timeout")
	current_arrow.modulate = arrow_modulate
	
