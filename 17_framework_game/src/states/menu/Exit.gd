extends State

export(String) var camera_name : String = "CameraExit"
export(String) var left_arrow_name : String = "LeftArrow"
export(String) var right_arrow_name : String = "RightArrow"
export(String) var game_delegate : String = "GameDelegate"
export(String) var action_name : String = "Quit"

func update(blackboard : Dictionary) -> void:
	blackboard[camera_name].enabled = true
	blackboard[left_arrow_name].visible = true
	blackboard[right_arrow_name].visible = false

	if action_name in blackboard:
		blackboard[game_delegate].exit()
