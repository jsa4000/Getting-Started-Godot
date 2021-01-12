tool
extends ActionDialog
class_name ActionItem

export(Resource) var item = InventoryItem.new()

var node: Node

func _init():
	type = Type.ITEM
	target_group = DEFAULT_TARGET_GROUP

func _execute(actor):
	scene = _get_scene_or_default()
	DialogManager.control.open(scene)
	yield(DialogManager.control, "control_closed")
	item = _get_item_or_default()
	if actor.inventory.add_item(item):
		node.hide()
		node.queue_free()
	else:
		print("The item must be full %d" % actor.inventory.size())
	emit_signal("action_finished", self)

func _get_item_or_default():
	if not item:
		return  InventoryItem.new()
	if not item.id:
		return InventoryManager.catalog[id]
	return item
