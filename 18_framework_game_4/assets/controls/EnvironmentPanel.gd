extends DebugPanel

var Definition = {
	"title": "Environment",
	"controls" : {
		0: {
			"name" : "Fog",
			"type" : Global.DataType.BOOL,
			"path" : "environment:fog_enabled"
		},
		1: {
			"name" : "Fog Light Color",
			"type" : Global.DataType.COLOR,
			"path" : "environment:fog_light_color",
			"depends_on" : 0
		},
		2: {
			"name" : "Fog Light Energy",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:fog_light_energy",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 0
		},
		3: {
			"name" : "Fog Sun Scatter",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:fog_sun_scatter",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 0
		},
		4: {
			"name" : "Fog Density",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:fog_density",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 1
			},
			"depends_on" : 0
		},
		5: {
			"name" : "Fog Aerial Perspective",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:fog_aerial_perspective",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 0
		},
		6: {
			"name" : "Fog Height",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:fog_height",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : -100,
				"max_value" : 100
			},
			"depends_on" : 0
		},
		7: {
			"name" : "Fog Height Density",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:fog_height_density",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 0
		},
		8: {
			"name" : "ToneMap Exposure",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:tonemap_exposure",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 16
			}
		},
		9: {
			"name" : "ToneMap White",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:tonemap_white",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 16
			}
		},
		10: {
			"name" : "Auto Exposure",
			"type" : Global.DataType.BOOL,
			"path" : "environment:auto_exposure_enabled"
		},
		11: {
			"name" : "SS Reflections",
			"type" : Global.DataType.BOOL,
			"path" : "environment:ss_reflections_enabled"
		},
		12: {
			"name" : "Ambient Occlusion",
			"type" : Global.DataType.BOOL,
			"path" : "environment:ssao_enabled"
		},
		13: {
			"name" : "Glow",
			"type" : Global.DataType.BOOL,
			"path" : "environment:glow_enabled"
		},
		14: {
			"name" : "Intensity",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:glow_intensity",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 13
		},
		15: {
			"name" : "Strength",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:glow_strength",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 2
			},
			"depends_on" : 13
		},
		16: {
			"name" : "Bloom",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:glow_bloom",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 1
			},
			"depends_on" : 13
		},
		17: {
			"name" : "Threshold",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:glow_hdr_threshold",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 4
			},
			"depends_on" : 13
		},
		18: {
			"name" : "Adjustments",
			"type" : Global.DataType.BOOL,
			"path" : "environment:adjustment_enabled"
		},
		19: {
			"name" : "Brightness",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:adjustment_brightness",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 18
		},
		20: {
			"name" : "Contrast",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:adjustment_contrast",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 18
		},
		21: {
			"name" : "Saturation",
			"type" : Global.DataType.SCALAR,
			"path" : "environment:adjustment_saturation",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 18
		},
#		22: {
#			"name" : "Far Blur",
#			"type" : Global.DataType.BOOL,
#			"path" : "environment:dof_blur_far_enabled"
#		},
#		23: {
#			"name" : "Distance",
#			"type" : Global.DataType.SCALAR,
#			"path" : "environment:dof_blur_far_distance",
#			"control" : "SliderControl",
#			"parameters": {
#				"step" : 0.001,
#				"min_value" : 0,
#				"max_value" : 100
#			},
#			"depends_on" : 10
#		},
#		24: {
#			"name" : "Transition",
#			"type" : Global.DataType.SCALAR,
#			"path" : "environment:dof_blur_far_transition",
#			"control" : "SliderControl",
#			"parameters": {
#				"step" : 0.001,
#				"min_value" : 0,
#				"max_value" : 100
#			},
#			"depends_on" : 10
#		},
#		25: {
#			"name" : "Amount",
#			"type" : Global.DataType.SCALAR,
#			"path" : "environment:dof_blur_far_amount",
#			"control" : "SliderControl",
#			"parameters": {
#				"step" : 0.001,
#				"min_value" : 0,
#				"max_value" : 1
#			},
#			"depends_on" : 10
#		},
#		26: {
#			"name" : "Near Blur",
#			"type" : Global.DataType.BOOL,
#			"path" : "environment:dof_blur_near_enabled"
#		},
#		27: {
#			"name" : "Distance",
#			"type" : Global.DataType.SCALAR,
#			"path" : "environment:dof_blur_near_distance",
#			"control" : "SliderControl",
#			"parameters": {
#				"step" : 0.001,
#				"min_value" : 0,
#				"max_value" : 100
#			},
#			"depends_on" : 14
#		},
#		28: {
#			"name" : "Transition",
#			"type" : Global.DataType.SCALAR,
#			"path" : "environment:dof_blur_near_transition",
#			"control" : "SliderControl",
#			"parameters": {
#				"step" : 0.001,
#				"min_value" : 0,
#				"max_value" : 100
#			},
#			"depends_on" : 14
#		},
#		29: {
#			"name" : "Amount",
#			"type" : Global.DataType.SCALAR,
#			"path" : "environment:dof_blur_near_amount",
#			"control" : "SliderControl",
#			"parameters": {
#				"step" : 0.001,
#				"min_value" : 0,
#				"max_value" : 1
#			},
#			"depends_on" : 14
#		}
	}
}

# TODO: Godot 4.0 needs to call to the inherited class if it is not a scene (See DayLight)
func _init():
	super()

func _get_definition() -> Dictionary:
	return Definition
	
