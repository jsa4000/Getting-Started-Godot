extends Node
class_name GameScene, "../icons/scene_view.svg"

export(Resource) var game_delegate : Resource

func _init():
	add_to_group(GameGlobal.SCENE_GROUP)
