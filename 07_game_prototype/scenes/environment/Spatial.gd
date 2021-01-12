tool
extends Spatial

export(Vector3) var direction = Vector3.RIGHT setget set_direction
export(float,0,360) var threshold_degrees = 60

signal actor_entered(body)

func set_direction(newVal):
	direction = newVal
	#var angle = transform.basis.z.angle_to( Vector3.up )
	look_at(direction,Vector3.UP)
