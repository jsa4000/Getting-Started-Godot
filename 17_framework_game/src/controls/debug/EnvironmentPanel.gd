extends DebugPanel

var Definition = {
	"title": "Environment",
	"controls" : {
		0: {
			"name" : "Fog",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:fog_enabled"
		},
		1: {
			"name" : "Fog Color",
			"type" : Global.DataType.COLOR,
			"path" : "WorldEnvironment:environment:fog_color",
			"depends_on" : 0
		},
		2: {
			"name" : "Fog Depth",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:fog_depth_enabled",
			"depends_on" : 0
		},
		3: {
			"name" : "Depth Begin",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:fog_depth_begin",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 0
		},
		4: {
			"name" : "Depth End",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:fog_depth_end",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 0
		},
		5: {
			"name" : "ToneMap Exposure",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:tonemap_exposure",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 16
			}
		},
		6: {
			"name" : "ToneMap White",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:tonemap_white",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.1,
				"min_value" : 0,
				"max_value" : 16
			}
		},
		7: {
			"name" : "Auto Exposure",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:auto_exposure_enabled"
		},
		8: {
			"name" : "SS Reflections",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:ss_reflections_enabled"
		},
		9: {
			"name" : "Ambient Occlusion",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:ssao_enabled"
		},
		10: {
			"name" : "Far Blur",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:dof_blur_far_enabled"
		},
		11: {
			"name" : "Distance",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:dof_blur_far_distance",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 10
		},
		12: {
			"name" : "Transition",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:dof_blur_far_transition",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 10
		},
		13: {
			"name" : "Amount",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:dof_blur_far_amount",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 1
			},
			"depends_on" : 10
		},
		14: {
			"name" : "Near Blur",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:dof_blur_near_enabled"
		},
		15: {
			"name" : "Distance",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:dof_blur_near_distance",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 14
		},
		16: {
			"name" : "Transition",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:dof_blur_near_transition",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 100
			},
			"depends_on" : 14
		},
		17: {
			"name" : "Amount",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:dof_blur_near_amount",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 1
			},
			"depends_on" : 14
		},
		18: {
			"name" : "Glow",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:glow_enabled"
		},
		19: {
			"name" : "Intensity",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:glow_intensity",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 18
		},
		20: {
			"name" : "Strength",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:glow_strength",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 2
			},
			"depends_on" : 18
		},
		21: {
			"name" : "Bloom",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:glow_bloom",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 1
			},
			"depends_on" : 18
		},
		22: {
			"name" : "Threshold",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:glow_intensity",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 4
			},
			"depends_on" : 18
		},
		23: {
			"name" : "Adjustments",
			"type" : Global.DataType.BOOL,
			"path" : "WorldEnvironment:environment:adjustment_enabled"
		},
		24: {
			"name" : "Brightness",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:adjustment_brightness",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 23
		},
		215: {
			"name" : "Contrast",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:adjustment_contrast",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 23
		},
		26: {
			"name" : "Saturation",
			"type" : Global.DataType.SCALAR,
			"path" : "WorldEnvironment:environment:adjustment_saturation",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.001,
				"min_value" : 0,
				"max_value" : 8
			},
			"depends_on" : 23
		},
	}
}

func _get_definition() -> Dictionary:
	return Definition
	
