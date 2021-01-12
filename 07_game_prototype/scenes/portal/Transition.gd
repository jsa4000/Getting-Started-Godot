extends PortalTransition

export(float,0,100) var duration = 6.0

onready var camera : Camera
onready var player : KinematicBody
onready var slider : CameraSlider
onready var player_position : Spatial = $PlayerPosition

func play():
	var animation = Tween.new()
	add_child(animation)
	animation.interpolate_property(
		slider, "unit_offset", 
		0, 1, duration,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	animation.interpolate_property(
		player, "global_transform:origin", 
		player.global_transform.origin, player_position.global_transform.origin, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	animation.start()
	yield(animation, "tween_completed")
	remove_child(animation)
	animation.queue_free()
	emit_signal("transition_completed", self, animation)

