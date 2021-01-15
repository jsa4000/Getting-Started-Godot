@tool
extends GameManager

var Scenes = {
	GameDelegate.Mode.INTRO : {
		"path": "res://assets/levels/Intro.tscn",
		"loading" : false
	},
	GameDelegate.Mode.MENU : {
		"path": "res://assets/levels/Menu.tscn",
		"loading" : true
	},
	GameDelegate.Mode.NEW : {
		"path": "res://assets/levels/Level01.tscn",
		"loading" : true
	},
	GameDelegate.Mode.LOAD : {
		"path": "res://assets/levels/Level02.tscn",
		"loading" : true
	}
}

func _get_scenes() -> Dictionary: 
	return Scenes
