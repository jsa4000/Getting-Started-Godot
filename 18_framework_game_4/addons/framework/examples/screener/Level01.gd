@tool
extends GameScene

func change_scene() -> void:
	game_delegate.change_mode(GameDelegate.Mode.LOAD)

# TODO: Seems to be some issue with the Bullet physics so this funcion is not called sometimes
func _on_Area3D_body_entered(body):
	change_scene() 
