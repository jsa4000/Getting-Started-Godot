extends CanvasTransition
class_name ViewportTransition, "../../icons/fade.svg"

export(ViewportTexture) var frontTexture
export(ViewportTexture) var backTexture

func _init_shader():
	._init_shader()
	_set_shader_textures(frontTexture, backTexture)

func _set_shader_textures(frontTexture: ViewportTexture, backTexture: ViewportTexture):
	_screen.material.set_shader_param("front_texture", frontTexture)
	_screen.material.set_shader_param("back_texture", backTexture)
	
