extends DebugPanel

var Definition = {
	"title": "Screener",
	"controls" : {
		0: {
			"name" : "Visible",
			"type" : Global.DataType.BOOL,
			"path" : "ColorRect:visible"
		},
		1: {
			"name" : "Color",
			"type" : Global.DataType.COLOR,
			"path" : "ColorRect:color"
		},
		2: {
			"name" : "Section",
			"type" : Global.DataType.STRING,
			"path" : "label",
			"control" : "DropdownControl",
			"parameters": {
				"options" : "Intro,Advanced,Other,None"
			}
		},
	}
}

# TODO: Godot 4.0 needs to call to the inherited class if it is not a scene (See DayLight)
func _init():
	super()
	
func _get_definition() -> Dictionary:
	return Definition
	
