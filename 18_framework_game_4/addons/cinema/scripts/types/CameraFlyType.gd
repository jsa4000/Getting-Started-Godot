@tool
class_name CameraFlyType extends CameraMotionType

@export var fly_speed : int = 10
@export var fly_accel : int = 4

func camera_process(delta: float) -> void:
	gimbal.direction = Vector3.ZERO
	var aim = gimbal.pivot.get_global_transform().basis
	if move_axis.x >= 0.5:
		gimbal.direction -= aim.z
	if move_axis.x <= -0.5:
		gimbal.direction += aim.z
	if move_axis.y <= -0.5:
		gimbal.direction -= aim.x
	if move_axis.y >= 0.5:
		gimbal.direction += aim.x
	gimbal.direction = gimbal.direction.normalized()
	
	var target: Vector3 = gimbal.direction * fly_speed
	gimbal.velocity = gimbal.velocity.lerp(target, fly_accel * delta)
	
	gimbal.velocity = gimbal.move_and_slide(gimbal.velocity)
