extends Node

@onready var dialog_player = $DialogPlayer

var is_playing : bool = false
var is_on_area : bool = false

# TODO: Godot 4.0 RichText visible percentage is not working properly
func _ready():
	dialog_player.control_closed.connect(_on_control_closed)

func _process(delta):
	if is_playing || not is_on_area:
		return
		
	if Input.is_key_pressed(KEY_1):
		dialog_player.play("statue", "needful")
		is_playing = true
	elif Input.is_key_pressed(KEY_2):
		dialog_player.play("statue", "greeting")
		is_playing = true
	elif Input.is_key_pressed(KEY_3):
		dialog_player.play("statue", "done")
		is_playing = true

func _on_control_closed(scene):
	is_playing = false

func _on_Area3D_body_entered(body):
	is_on_area = true
	
func _on_Area3D_body_exited(body):
	is_on_area = false
