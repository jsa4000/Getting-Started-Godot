@tool
class_name ColorTransition extends CanvasTransition
@icon("../../icons/fade.svg")

@export var color : Color = Color.black

func _init_shader():
	super()
	_set_shader_color(color)

func _set_shader_color(color: Color):
	_screen.material.set_shader_param("color", color)
	
