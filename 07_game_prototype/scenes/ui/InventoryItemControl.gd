extends Control
class_name InventoryItemControl

const Aura2DShader = preload("res://shaders/Aura2D.tres")

onready var image : TextureRect = $Container/Image
onready var label : Label = $Container/Label

var selected : bool = false setget set_selected, is_selected
var item : InventoryItem setget set_item

func set_item(newVVal : InventoryItem):
	item = newVVal
	if not item :
		image.texture = null
		label.text = ""
		return
	image.texture = item.texture
	label.text = item.name

func set_selected(newVal):
	selected = newVal;
	if selected:
		image.material = Aura2DShader
	else:
		image.material = null;

func is_selected() -> bool:
	return selected;

func _ready():
	pass
	

