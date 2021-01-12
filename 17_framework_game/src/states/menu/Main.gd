extends State

export(String) var __I_N_P_U_T_S__

export(String) var camera_name : String = "CameraMain"
export(String) var left_arrow_name : String = "LeftArrow"
export(String) var right_arrow_name : String = "RightArrow"

export(Font) var theme_option_enabled : Font
export(Font) var theme_option_disabled : Font
export(String) var option_selected : String = "OptionSelected"
export(String) var effect_selected : String = "EffectSelected"
export(String) var newgame_button_name : String = "NewGame"
export(String) var continue_button_name : String = "Continue"

export(String) var __O_U_T_P_U_T_S__

export(String) var mode_selected : String = "ModeSelected"

var _previous_option : int = -1

func update(blackboard : Dictionary) -> void:
	blackboard[camera_name].enabled = true	
	blackboard[left_arrow_name].visible = true
	blackboard[right_arrow_name].visible = true

	if not option_selected in blackboard:
		blackboard[option_selected] = 0
		
	var current_option = blackboard[option_selected]
	if current_option >= 1:
		blackboard[option_selected] = 1
		blackboard[newgame_button_name].set("custom_fonts/font",theme_option_disabled)
		blackboard[continue_button_name].set("custom_fonts/font",theme_option_enabled)
		blackboard[mode_selected] = GameDelegate.Mode.LOAD
		
	else:
		blackboard[option_selected] = 0
		blackboard[newgame_button_name].set("custom_fonts/font",theme_option_enabled)
		blackboard[continue_button_name].set("custom_fonts/font",theme_option_disabled)
		blackboard[mode_selected] = GameDelegate.Mode.NEW
	 
	if current_option != _previous_option:
		if _previous_option != -1:
			blackboard[effect_selected].playing = true
		_previous_option = current_option
