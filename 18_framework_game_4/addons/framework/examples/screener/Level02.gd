@tool
extends GameScene

func change_scene() -> void:
	game_delegate.change_mode(GameDelegate.Mode.INTRO)

func _on_Area3D_body_entered(body):
	change_scene() 
