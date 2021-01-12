extends Transition
class_name ColorTransition

export(Color) var color = Color.black

func _init_shader():
	._init_shader()
	_set_shader_color(color)

func _set_shader_color(color: Color):
	_screen.material.set_shader_param("color", color)
	
