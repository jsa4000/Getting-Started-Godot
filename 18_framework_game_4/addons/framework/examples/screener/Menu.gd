@tool
extends GameScene

func change_scene() -> void:
	game_delegate.change_mode(GameDelegate.Mode.NEW)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		change_scene()
