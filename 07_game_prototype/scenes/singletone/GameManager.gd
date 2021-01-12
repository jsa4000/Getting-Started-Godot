extends Node

const ALL_SCENES = {
	"menu": "res://scenes/ui/Menu.tscn", 
	"world": "res://scenes/worlds/World.tscn", 
	"world2": "res://scenes/worlds/World2.tscn"
	}

var scene = "menu" setget set_scene

func set_scene(newVal):
	scene = newVal
	_change_scene(scene)
	
func _ready():
	_change_scene(scene)

func _change_scene(scene):
	get_tree().change_scene(ALL_SCENES[scene])
