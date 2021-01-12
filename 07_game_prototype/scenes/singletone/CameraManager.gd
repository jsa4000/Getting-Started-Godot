extends Node

onready var camera : Camera setget set_camera

func set_camera(newVal):
	camera = newVal

func world_point(world_point : Vector3) -> Vector2:
	return camera.unproject_position(world_point)
