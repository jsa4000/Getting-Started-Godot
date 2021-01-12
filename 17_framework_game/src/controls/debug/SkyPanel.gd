extends DebugPanel

var Definition = {
	"title": "Sky",
	"controls" : {
		0: {
			"name" : "Visible",
			"type" : Global.DataType.BOOL,
			"path" : "SkyViewport/Texture:visible"
		},
		1: {
			"name" : "Time Of Day",
			"type" : Global.DataType.SCALAR,
			"path" : "time_of_day_setup",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.000001,
				"min_value" : 0,
				"max_value" : 1
			}
		},
		2: {
			"name" : "Sky Fov",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:background_sky_custom_fov",
			"control" : "SliderControl",
			"parameters": {
				"step" : 1,
				"min_value" : 0,
				"max_value" : 180
			}
		},
		3: {
			"name" : "Sky Rotation",
			"type" : Global.DataType.VECTOR3,
			"path" : "sky_rotation"
		},
		4: {
			"name" : "Ambient Light Energy",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:ambient_light_energy",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 16
			}
		},
		5: {
			"name" : "Sky Contribution",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:ambient_light_sky_contribution",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 1
			}
		},
		6: {
			"name" : "Scatteringg",
			"type" : Global.DataType.BOOL,
			"path" : "SCATERRING"
		},
		7: {
			"name" : "Color",
			"type" : Global.DataType.COLOR,
			"path" : "color_sky",
			"depends_on" : 6
		},
		8: {
			"name" : "Tone",
			"type" : Global.DataType.SCALAR,
			"path" : "sky_tone",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 10
			},
			"depends_on" : 6
		},
		9: {
			"name" : "Density",
			"type" : Global.DataType.SCALAR,
			"path" : "sky_density",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 2
			},
			"depends_on" : 6
		},
		10: {
			"name" : "Rayleigh Coefficient",
			"type" : Global.DataType.SCALAR,
			"path" : "sky_rayleig_coeff",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 10
			},
			"depends_on" : 6
		},
		11: {
			"name" : "Mie Coefficient",
			"type" : Global.DataType.SCALAR,
			"path" : "sky_mie_coeff",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 10
			},
			"depends_on" : 6
		},
		12: {
			"name" : "Multi Scatter Phase",
			"type" : Global.DataType.SCALAR,
			"path" : "multiScatterPhase",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 2
			},
			"depends_on" : 6
		},
		13: {
			"name" : "Anisotropic Intensity",
			"type" : Global.DataType.SCALAR,
			"path" : "anisotropicIntensity",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : -2,
				"max_value" : 2
			},
			"depends_on" : 6
		},
		14: {
			"name" : "Moon Light",
			"type" : Global.DataType.COLOR,
			"path" : "moon_light"
		},
		15: {
			"name" : "Sunset Light",
			"type" : Global.DataType.COLOR,
			"path" : "sunset_light"
		},
		16: {
			"name" : "Duy Light",
			"type" : Global.DataType.COLOR,
			"path" : "day_light"
		},
		17: {
			"name" : "Moon Tint",
			"type" : Global.DataType.COLOR,
			"path" : "moon_tint"
		},
		18: {
			"name" : "Sun Radius",
			"type" : Global.DataType.SCALAR,
			"path" : "sun_radius",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 1
			}
		},
		19: {
			"name" : "Moon Radius",
			"type" : Global.DataType.SCALAR,
			"path" : "moon_radius",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : 0,
				"max_value" : 0.5
			}
		},
		20: {
			"name" : "Mooon Phase",
			"type" : Global.DataType.SCALAR,
			"path" : "moon_phase",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.0001,
				"min_value" : -1,
				"max_value" : 1
			}
		},
		21: {
			"name" : "God Rays",
			"type" : Global.DataType.BOOL,
			"path" : "enable_god_rays"
		}
	}
}

func _get_definition() -> Dictionary:
	return Definition
	
