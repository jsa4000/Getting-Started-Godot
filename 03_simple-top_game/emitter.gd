extends Node2D

var trail = load("res://Trail.tscn")
onready var scene = get_node("../../")
export var velocityTrigger = 500

func _on_Player_on_moving(p_position, p_direction, p_velocity):
	if p_velocity > velocityTrigger:
		var sparks = trail.instance()
		sparks.set_position(p_position)
		sparks.rotate(Vector2.DOWN.angle_to((p_direction - position).normalized()))
		sparks.set_emitting(true)
		scene.add_child(sparks)
		
		# Subscribe to end for the particle to free memory?
		#sparks.connect("my_signal", self, "_on_my_signal")
