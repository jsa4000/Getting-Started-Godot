extends DebugPanel

var Definition = {
	"title": "Cinema",
	"controls" : {
		0: {
			"name" : "Camera",
			"type" : Global.DataType.STRING,
			"path" : "camera_id",
			"control" : "DropdownControl",
			"parameters": {
				"options" : "CameraFps,CameraFly"
			}
		},
		1: {
			"name" : "Fov",
			"type" : Global.DataType.SCALAR,
			"path" : "Gimbal/Pivot/Camera:fov",
			"control" : "SliderControl",
			"parameters": {
				"step" : 1,
				"min_value" : 1,
				"max_value" : 180
			}
		},
		2: {
			"name" : "Offset",
			"type" : Global.DataType.VECTOR3,
			"path" : "head_offset"
		},
		3: {
			"name" : "MotionBlur",
			"type" : Global.DataType.BOOL,
			"path" : "Gimbal:motion_blur_enabled"
		},
		4: {
			"name" : "Iteration Count",
			"type" : Global.DataType.SCALAR,
			"path" : "Gimbal/Pivot/Camera/MotionBlur:material/0:shader_param/iteration_count",
			"control" : "SliderControl",
			"parameters": {
				"step" : 1,
				"min_value" : 0,
				"max_value" : 50
			},
			"depends_on" : 3
		},
		5: {
			"name" : "Intensity",
			"type" : Global.DataType.SCALAR,
			"path" : "Gimbal/Pivot/Camera/MotionBlur:material/0:shader_param/intensity",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.01,
				"min_value" : 0,
				"max_value" : 1
			},
			"depends_on" : 3
		},
		6: {
			"name" : "PostProcess",
			"type" : Global.DataType.BOOL,
			"path" : "PostProcess:visible"
		},
		7: {
			"name" : "Light",
			"type" : Global.DataType.SCALAR,
			"path" : "PostProcess:material:shader_param/light",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.01,
				"min_value" : 0,
				"max_value" :1
			},
			"depends_on" : 6
		},
		8: {
			"name" : "Extend",
			"type" : Global.DataType.SCALAR,
			"path" : "PostProcess:material:shader_param/extend",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.01,
				"min_value" : 0,
				"max_value" :1
			},
			"depends_on" : 6
		},
		9: {
			"name" : "Offset",
			"type" : Global.DataType.SCALAR,
			"path" : "PostProcess:material:shader_param/offset",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.01,
				"min_value" : 0,
				"max_value" :10
			},
			"depends_on" : 6
		},
		10: {
			"name" : "Type",
			"type" : Global.DataType.STRING,
			"path" : "Composition:type",
			"control" : "DropdownControl",
			"parameters": {
				"options" : "None,RuleOfThirds,FibonacciSpiral,GoldenRatio"
			}
		},
		11: {
			"name" : "Transparency",
			"type" : Global.DataType.SCALAR,
			"path" : "Composition:transparency",
			"control" : "SliderControl",
			"parameters": {
				"step" : 0.01,
				"min_value" : 0,
				"max_value" :1
			}
		},
		12: {
			"name" : "Flip H",
			"type" : Global.DataType.BOOL,
			"path" : "Composition:flip_h"
		},
		13: {
			"name" : "Flip V",
			"type" : Global.DataType.BOOL,
			"path" : "Composition:flip_v"
		}
	}
}

var _cameras_ids : String

# TODO: Godot 4.0 needs to call to the inherited class if it is not a scene (See DayLight)
func _init():
	super()

func _get_definition() -> Dictionary:
	_set_cinema_parameters()
	return Definition
	
func _set_cinema_parameters() -> void:
	if _cameras_ids.is_empty():
		_cameras_ids = _get_cameras_id()
		# TODO: Godot 4.0 does not allo access dictinoaries by index
		#Definition.controls[0].parameters.options = _cameras_ids
		var options = "options"
		Definition.get("controls")[0].get("parameters")[options] = _cameras_ids
	
func _get_cameras_id() -> String:
	var result = PackedStringArray()
	var nodes = get_tree().get_nodes_in_group(CinemaGlobal.CAMERA_GROUP) 
	for node in nodes:
		if not owner.is_a_parent_of(node):
			continue
		result.append(node.id)
	return ",".join(result)

func _input(event: InputEvent) -> void:
	pass

