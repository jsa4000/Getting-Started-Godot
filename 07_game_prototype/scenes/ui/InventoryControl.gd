extends Control
class_name InventoryControl

const InventoryItemControlClass = preload("res://scenes/ui/InventoryItemControl.tscn")

onready var tween : Tween = $Tween
onready var panel : InventoryPanel = $InventoryPanel
onready var scroll : ScrollContainer = $ViewportContainer/Viewport/Main/ScrollContainer
onready var container : VBoxContainer = $ViewportContainer/Viewport/Main/ScrollContainer/ItemsContainer

var inventory setget set_inventory

signal control_opened(inventory)
signal control_closed()
signal item_selected(item)

func _ready():
	InventoryManager.set_control(self)
	
func open(world_point : Vector3):
	if is_visible():
		return
	rect_position = _get_position(world_point)
	show()
	if inventory && inventory.size():
		scroll.scroll_vertical = 0
		_focus_item(0)
		_show_panel(0)
	emit_signal("control_opened", inventory)
	
func close():
	hide()
	panel.hide()
	emit_signal("control_closed")
	
func set_inventory(newVal):
	inventory = newVal
	if not inventory:
		return
	inventory.connect("inventory_changed",self,"_on_inventory_changed")
	update_inventory()

func update_inventory():
	clean_inventory()
	for item in inventory.items:
		var item_control = InventoryItemControlClass.instance()
		container.add_child(item_control)
		item_control.set_item(item)
	# Add an empty  last item (not selectable)
	var item_control = InventoryItemControlClass.instance()
	container.add_child(item_control)
	item_control.set_item(null)

func clean_inventory():
	for child in container.get_children():
		child.remove_child(child)
		child.queue_free()

func _input(event):	
	if not is_visible():
		return
		
	if event.is_action_pressed("ui_up"):
		_scroll_vertical(false)
	if event.is_action_pressed("ui_down"): 
		_scroll_vertical(true)
	if inventory && inventory.size() && event.is_action_released("ui_accept"):
		print("selected item %s" % container.get_child(_get_current_item()).item)
		emit_signal("item_selected", container.get_child(_get_current_item()).item)
	
func _process(delta):
	if not is_visible():
		return

func _on_inventory_changed(newVal):
	self.set_inventory(newVal)
	
func  _get_position(world_point : Vector3) -> Vector2:
	var screen_pos = CameraManager.world_point(world_point)
	screen_pos.x += rect_size.x / 2
	screen_pos.y -= rect_size.y / 2	
	return screen_pos
	
func _scroll_vertical(down):
	var item_size = _get_item_size().y * (1 if down else -1)
	if (_get_item_count() - 2) * abs(item_size) < scroll.scroll_vertical + item_size:
		return
	tween.interpolate_property(
		scroll, "scroll_vertical", 
		scroll.scroll_vertical, scroll.scroll_vertical + item_size, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	_focus_item(_get_current_item())
	_show_panel(_get_current_item())

func _get_item_size() -> Vector2:
	for child in container.get_children():
		return child.rect_size
	return Vector2.ZERO
	
func _get_item_count() -> int:
	return container.get_children().size()	

func _get_current_item() -> int:
	if scroll.scroll_vertical:
		return int(round(scroll.scroll_vertical / _get_item_size().y))
	return 0

func _focus_item(index):
	for child in container.get_children():
		if child == container.get_child(index):
			child.selected = true
		else:	
			child.selected = false
			
func _show_panel(index):
	panel.set_item(container.get_child(index).item)
	panel.popup_centered(Vector2(rect_size.y, rect_size.y))
	panel.rect_position = Vector2(rect_position.x - (panel.rect_size.x) , rect_position.y)
