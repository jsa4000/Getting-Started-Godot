@tool
extends GameManager

var Scenes = {
	GameDelegate.Mode.INTRO : {
		"path": "res://assets/levels/Level01.tscn",
		"loading" : false
	},
	GameDelegate.Mode.MENU : {
		"path": "res://assets/examples/scenes/Menu.tscn",
		"loading" : true
	},
	GameDelegate.Mode.NEW : {
		"path": "res://assets/examples/scenes/Scene01.tscn",
		"loading" : true
	},
	GameDelegate.Mode.LOAD : {
		"path": "res://assets/examples/scenes/Scene02.tscn",
		"loading" : true
	}
}

func _get_scenes() -> Dictionary: 
	return Scenes
