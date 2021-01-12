tool
extends MeshInstance

var _material
var _camera
var _prev_camera_pos = Vector3()
var _prev_camera_rot = Quat()

func _ready():
	_camera = get_parent()
	_material =  get_surface_material(0)

func _process(delta):
	if _camera == null:
		return
	
	# Linear velocity is just difference in positions between two frames.
	var velocity = _camera.global_transform.origin - _prev_camera_pos
	
	# Angular velocity is a little more complicated, as you can see.
	# See https://math.stackexchange.com/questions/160908/how-to-get-angular-velocity-from-difference-orientation-quaternion-and-time
	var cam_rot = Quat(_camera.global_transform.basis)
	var cam_rot_diff = cam_rot - _prev_camera_rot
	var cam_rot_conj = conjugate(cam_rot)
	var ang_vel = (cam_rot_diff * 2.0) * cam_rot_conj; 
	ang_vel = Vector3(ang_vel.x, ang_vel.y, ang_vel.z) # Convert Quat to Vector3
	
	_material.set_shader_param("linear_velocity", velocity)
	_material.set_shader_param("angular_velocity", ang_vel)
		
	_prev_camera_pos = _camera.global_transform.origin
	_prev_camera_rot = Quat(_camera.global_transform.basis)
	
# Calculate the conjugate of a quaternion.
func conjugate(quat):
	return Quat(-quat.x, -quat.y, -quat.z, quat.w)
