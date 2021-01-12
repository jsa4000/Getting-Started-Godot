extends Control

signal start_button_pressed()
signal config_button_pressed()
signal exit_button_pressed()

func _on_StartButton_button_up():
	GameManager.set_scene("world")
	emit_signal("start_button_pressed")

func _on_ConfigButtton_button_up():
	emit_signal("config_button_pressed")

func _on_ExitButtton2_button_up():
	emit_signal("exit_button_pressed")
	get_tree().quit()
