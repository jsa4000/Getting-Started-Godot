extends DebugPanel

var Definition = {
	"title": "Sky",
	"controls" : {
		0: {
			"name" : "Use In Sky Only",
			"type" : Global.DataType.BOOL,
			"path" : "use_in_sky_only"
		},
		1: {
			"name" : "Light Color",
			"type" : Global.DataType.COLOR,
			"path" : "light_color"
		},
		2: {
			"name" : "Light Energy",
			"type" : Global.DataType.SCALAR,
			"path" : "light_energy",
			"control" : "SliderControl",
			"parameters": {
				"step" :0.0001,
				"min_value" : 0,
				"max_value" : 100
			}
		},
		3: {
			"name" : "Rotation degrees",
			"type" : Global.DataType.VECTOR3,
			"path" : "rotation_degrees"
		}
	}
}

# TODO: Godot 4.0 needs to call to the inherited class if it is not a scene (See DayLight)
func _init():
	super()

func _get_definition() -> Dictionary:
	return Definition
	
