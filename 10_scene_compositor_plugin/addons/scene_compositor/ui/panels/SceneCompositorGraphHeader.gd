tool
extends HBoxContainer
class_name SceneCompositorGraphHeader

onready var node_list = $NodeList

signal save_pressed()
signal load_pressed()
signal run_pressed()

func _ready():
	pass

func _on_Run_pressed():
	emit_signal("run_pressed")

func _on_Save_pressed():
	emit_signal("save_pressed")

func _on_Load_pressed():
	emit_signal("load_pressed")
