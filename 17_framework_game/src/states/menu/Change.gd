extends State

export(String) var game_delegate : String = "GameDelegate"
export(String) var mode_selected : String = "ModeSelected"

func update(blackboard : Dictionary) -> void:
	if mode_selected in blackboard:
		blackboard[game_delegate].change_mode(blackboard[mode_selected])
		blackboard.erase(mode_selected)
