extends KinematicBody2D

export var maxVelocity = 1200.0
export var stopRadius = 15.0
export var stadilyRadius = 200.0
var direction : Vector2
var velocity = 0.0
var random = RandomNumberGenerator.new()

signal on_moving(position, direction, velocity)

func _ready():
	# Point initially to the mouse pointer
	direction = get_viewport().get_mouse_position() - position
	$icon.rotate(Vector2.UP.angle_to(direction.normalized()))

# warning-ignore:unused_argument
func _physics_process(delta):
	var new_direction = get_viewport().get_mouse_position() - position
	# Stop following the mouse inside a radius
	if new_direction.length() > stopRadius:
		$icon.rotate(direction.angle_to(new_direction))
		if new_direction.length() < stadilyRadius:
			velocity = lerp(velocity, 0, 0.1)
			#print("Slow Down at %f" % velocity)
		else:
			velocity = lerp(velocity, maxVelocity, 0.1)
			#print("Moving at %f" % velocity)
			# Use a non linear velocitty, more realiztit (smooth)
			velocity = random.randfn(velocity, 25)	
		move_and_slide(new_direction.normalized() * velocity)
		direction = new_direction
		# Call to on_moving event
		emit_signal("on_moving", position, direction, velocity)

