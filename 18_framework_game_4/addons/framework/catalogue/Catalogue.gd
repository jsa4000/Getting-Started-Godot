@tool
class_name Catalogue extends Inventory
@icon("../icons/inventory.svg")

@export var enabled : bool= true
@export_node_path var actor_path : NodePath
# TODO: Godot 4 does not allow to explicity set the type
@export var items : Array = []

var _actor : Node
var _data : Dictionary = {}

func _init():
	add_to_group(CatalogueGlobal.INVENTORY_GROUP)

func _ready():
	_set_actor_by_path(actor_path)
	if Engine.is_editor_hint():
		return
	_init_items()
	
func _init_items():
	for item in items:
		_data[item.id] = item
		
func size() -> int:
	return _data.size()
	
# TODO: Godot 4 error calling to this methid because the type since it is not recognized
#func add_item(item : CatalogueItem) -> void:
func add_item(item) -> void:
	if has(item.id):
		_data[item.id] = item
		self.item_updated.emit(item)
	else:
		_data[item.id] = item
		self.item_added.emit(item)

func get_item(id) -> CatalogueItem:
	return _data[id]

func has(id) -> bool:
	return _data.has(id)

func remove(id) -> void:
	if has(id):
		var item = get(id)
		_data.erase(id)
		self.item_removed.emit(item)
		
func _set_actor_by_path(value : NodePath) -> void:
	_actor = get_node_or_null(value)
	if _actor == null:
		_actor = get_parent()
