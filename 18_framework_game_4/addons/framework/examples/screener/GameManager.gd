@tool
extends GameManager

var Scenes = {
	GameDelegate.Mode.INTRO : {
		"path": "res://addons/framework/examples/screener/Intro.tscn",
		"loading" : false
	},
	GameDelegate.Mode.MENU  : {
		"path": "res://addons/framework/examples/screener/Menu.tscn",
		"loading" : true
	},
	GameDelegate.Mode.NEW  : {
		"path": "res://addons/framework/examples/screener/CutScene01.tscn",
		"loading" : true
	}
}

func _get_scenes() -> Dictionary: 
	return Scenes
