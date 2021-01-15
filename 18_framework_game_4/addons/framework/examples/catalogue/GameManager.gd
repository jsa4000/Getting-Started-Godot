@tool
extends GameManager

var Scenes = {
	GameDelegate.Mode.INTRO : {
		"path": "res://assets/levels/Intro.tscn",
		"loading" : false
	}
}

func _get_scenes() -> Dictionary: 
	return Scenes
