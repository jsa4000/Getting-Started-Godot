# TODO: Godot 4.0 need to add @Tool annotation to almost every script to work.
@tool
extends GameScene

func _process(delta):
	if Engine.is_editor_hint():
		return
	if Input.is_key_pressed(KEY_1):
		game_delegate.change_mode(GameDelegate.Mode.INTRO)
	elif Input.is_key_pressed(KEY_2):
		game_delegate.change_mode(GameDelegate.Mode.MENU)
	elif Input.is_key_pressed(KEY_3):
		game_delegate.change_mode(GameDelegate.Mode.NEW)
	elif Input.is_key_pressed(KEY_4):
		game_delegate.change_mode(GameDelegate.Mode.LOAD)
