extends Inventory
class_name Catalogue, "../icons/inventory.svg"

export (bool) var enabled = true
export(NodePath) var actor_path : NodePath setget _set_actor_path
export(Array,Resource) var items : Array

var _actor : Node
var _data : Dictionary = {}

func _init():
	add_to_group(CatalogueGlobal.INVENTORY_GROUP)

func _ready():
	_set_actor_path(actor_path)
	_init_items()
	
func _init_items():
	for item in items:
		_data[item.id] = item
		
func size() -> int:
	return _data.size()
	
func add(item : CatalogueItem) -> void:
	if has(item.id):
		_data[item.id] = item
		emit_signal("item_updated", item)
	else:
		_data[item.id] = item
		emit_signal("item_added", item)

func get(id) -> CatalogueItem:
	return _data[id]

func has(id) -> bool:
	return _data.has(id)

func remove(id) -> void:
	if has(id):
		var item = get(id)
		_data.erase(id)
		emit_signal("item_removed", item)
		
func _set_actor_path(value : NodePath) -> void:
	actor_path = value
	if not is_inside_tree():
		return
	_actor = get_node_or_null(actor_path)
	if _actor == null:
		_actor = get_parent()
		if _actor != null:
			actor_path = _actor.get_path()
