extends SpotLight

export(Array, Color) var colors : Array = [Color.blue, Color.red, Color.violet, Color.yellow, Color.green]

var _index = 0

func _on_Timer_timeout():
	if _index >= colors.size():
		_index = 0
	light_color = colors[_index]
	_index += 1
