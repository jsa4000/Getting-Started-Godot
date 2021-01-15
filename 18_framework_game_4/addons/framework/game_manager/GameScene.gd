@tool
class_name GameScene extends Node
@icon("../icons/scene_view.svg")

@export var game_delegate : Resource

func _init():
	add_to_group(GameGlobal.SCENE_GROUP)
