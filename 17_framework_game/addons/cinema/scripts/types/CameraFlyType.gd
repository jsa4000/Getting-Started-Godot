extends CameraMotionType
class_name CameraFlyType

export(int) var fly_speed = 10
export(int) var fly_accel = 4

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
	gimbal.velocity = gimbal.velocity.linear_interpolate(target, fly_accel * delta)
	
	gimbal.velocity = gimbal.move_and_slide(gimbal.velocity)
