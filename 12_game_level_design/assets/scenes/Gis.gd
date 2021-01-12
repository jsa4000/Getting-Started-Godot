extends Spatial

onready var sky_b = $Sky/Sprite

func ready():
	var iChannel=sky_b.get_viewport().get_texture()
	
	var camera = get_viewport().get_camera()
	camera.environment=load("res://default_env.tres") as Environment
	camera.environment.background_sky.set_panorama(iChannel)

