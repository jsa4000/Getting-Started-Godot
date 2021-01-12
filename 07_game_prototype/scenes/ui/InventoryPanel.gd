extends Popup
class_name InventoryPanel

onready var image : TextureRect = $Image
onready var label : Label = $Container/Label
onready var description : RichTextLabel = $Container/Description

var item : InventoryItem setget set_item

func set_item(newVal : InventoryItem):
	item = newVal
	if not item :
		image.texture = null
		label.text = ""
		description.bbcode_text = ""
		return
	image.texture = item.texture
	label.text = item.name
	description.bbcode_text = item.caption

func _ready():
	pass
