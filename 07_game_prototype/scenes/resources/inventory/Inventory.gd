extends Resource
class_name Inventory

const DEFAULT_MAX_ITEMS = 10

export(String) var id
export(int) var max_items = DEFAULT_MAX_ITEMS
export(Array, Resource) var items

signal inventory_changed(inventory)

func add_item(item) -> bool:
	if item && items.size() >= max_items:
		return false;
	items.append(item)
	emit_signal("inventory_changed",self)
	return true
	
func remove_item(id) -> void:
	for item in items:
		if item.id == id:
			items.errase(item)
			emit_signal("inventory_changed",self)
	
func get_item(id) -> InventoryItem:
	for item in items:
		if item.id == id:
			return item
	return null

func size() -> int: return items.size()
