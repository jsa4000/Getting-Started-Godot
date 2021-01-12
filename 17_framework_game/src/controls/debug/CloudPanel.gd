extends DebugPanel

var Definition = {
	"title": "Clouds",
	"controls" : {
		0: {
			"name" : "Visible",
			"type" : Global.DataType.BOOL,
			"path" : "CloudsViewport/Texture:visible"
		},
		1: {
			"name" : "Coverage",
			"type" : Global.DataType.SCALAR,
			"path" : "clouds_coverage",
			"control" : "SliderControl",
			"parameters": {
				"step" :0.0001,
				"min_value" : 0,
				"max_value" : 1
			}
		},
		2: {
			"name" : "Size",
			"type" : Global.DataType.SCALAR,
			"path" : "clouds_size",
			"control" : "SliderControl",
			"parameters": {
				"step" :0.0001,
				"min_value" : 0,
				"max_value" : 10
			}
		},
		3: {
			"name" : "Softness",
			"type" : Global.DataType.SCALAR,
			"path" : "clouds_softness",
			"control" : "SliderControl",
			"parameters": {
				"step" :0.0001,
				"min_value" : 0,
				"max_value" : 10
			}
		},
		4: {
			"name" : "Density",
			"type" : Global.DataType.SCALAR,
			"path" : "clouds_dens",
			"control" : "SliderControl",
			"parameters": {
				"step" :0.0001,
				"min_value" : 0,
				"max_value" : 1
			}
		},
		5: {
			"name" : "Height",
			"type" : Global.DataType.SCALAR,
			"path" : "clouds_height",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 1
			}
		},
		6: {
			"name" : "Quality",
			"type" : Global.DataType.SCALAR,
			"path" : "clouds_quality",
			"control" : "SliderControl",
			"parameters": {
				"step" : 1,
				"min_value" : 1,
				"max_value" : 100
			}
		},
		7: {
			"name" : "Color",
			"type" : Global.DataType.COLOR,
			"path" : "clouds_tint"
		},
		8: {
			"name" : "Wind Direction",
			"type" : Global.DataType.VECTOR2,
			"path" : "wind_dir"
		},
		9: {
			"name" : "Wind Strength",
			"type" : Global.DataType.SCALAR,
			"path" : "wind_strength",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 1
			}
		}
	}
}

func _get_definition() -> Dictionary:
	return Definition
	
