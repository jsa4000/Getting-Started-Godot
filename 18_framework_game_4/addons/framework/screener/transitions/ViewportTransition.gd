@tool
class_name ViewportTransition extends CanvasTransition
@icon("../../icons/fade.svg")

@export var frontTexture : ViewportTexture
@export var backTexture : ViewportTexture

func _init_shader():
	super()
	_set_shader_textures(frontTexture, backTexture)

func _set_shader_textures(frontTexture: ViewportTexture, backTexture: ViewportTexture):
	_screen.material.set_shader_param("front_texture", frontTexture)
	_screen.material.set_shader_param("back_texture", backTexture)
	
