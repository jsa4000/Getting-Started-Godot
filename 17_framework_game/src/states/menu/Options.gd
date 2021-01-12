extends State

export(String) var camera_name : String = "CameraOptions"
export(String) var left_arrow_name : String = "LeftArrow"
export(String) var right_arrow_name : String = "RightArrow"

func update(blackboard : Dictionary) -> void:
	blackboard[camera_name].enabled = true
	blackboard[left_arrow_name].visible = true
	blackboard[right_arrow_name].visible = true

