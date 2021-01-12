tool
extends Panel
class_name SceneCompositorProperties

onready var _slots = $Layout/Slots
onready var _label = $Layout/Label

func _ready():
	pass 
	
func set_node(node):
	_clean_slots()
	if not node:
		return
	_label.text = node.title
	for child in node.get_children():
		if child is SlotControl && child.get_connection_type() != Global.ConnectorType.OUTPUT \
			&& child.has_control():
			var slot = child.duplicate()
			slot.rect_size = Vector2(70,50)
			slot.rect_min_size = Vector2(70,50)
			slot.size_flags_vertical = SIZE_FILL
			_slots.add_child(slot)
			
func _clean_slots():
	for child in _slots.get_children():
		_slots.remove_child(child)
		child.queue_free()
