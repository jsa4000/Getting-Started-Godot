@tool
extends Node

@export_node_path var inventory : NodePath
@export var item_1 : Resource
@export var item_2 : Resource

@onready var _inventory : Inventory = get_node(inventory)

func _ready():
	if Engine.is_editor_hint():
		return
	# TODO: In Godot 4.0 The 'Object' item in the selection types (Array) does not work
	call_deferred("_init_inventory")

func _init_inventory():
	if item_1 != null:
		_inventory.add_item(item_1 as CatalogueCardItem)
	if item_2 != null:
		_inventory.add_item(item_2 as CatalogueCardItem)
