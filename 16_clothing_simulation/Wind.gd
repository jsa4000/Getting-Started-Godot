extends Spatial

onready var wind_player = $Force/AnimationPlayer

export (float) var max_speed : float = 1.0

func _ready():
	_apply_force()

func _on_Timer_timeout():
	_apply_force()

func _apply_force():
	wind_player.play("Wind", -1, rand_range(0.0, max_speed))
