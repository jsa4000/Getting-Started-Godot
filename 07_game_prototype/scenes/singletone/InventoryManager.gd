extends Node

const TEXTURES_PATH = "res://assets/inventory/items/"
const CATALOG_PATH = "res://assets/inventory/catalog/"
const TEXTURES_EXTENSION = ".png"
const CATALOG_EXTENSION = ".json"

onready var control : InventoryControl setget set_control
onready var textures : Dictionary
onready var catalog : Dictionary

func set_control(newVal):
	control = newVal

func _ready():
	_load_textures()
	_load_catalog()
	
	print("Sucessfully Loaded %s textures" % textures.size())
	print("Sucessfully Loaded %s catalog" % catalog.size())

func _load_textures():
	var dir = Directory.new()
	if dir.open(TEXTURES_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if !dir.current_is_dir() && file_name.ends_with(TEXTURES_EXTENSION):
				textures[file_name.get_basename()] = ResourceLoader.load(TEXTURES_PATH + file_name)
			file_name = dir.get_next()

func _load_catalog():
	var dir = Directory.new()
	if dir.open(CATALOG_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if !dir.current_is_dir() && file_name.ends_with(CATALOG_EXTENSION):
				_load_json(CATALOG_PATH + file_name)
			file_name = dir.get_next()

func _load_json(file_name):
	var f := File.new()
	f.open(file_name, File.READ)
	var result_json := JSON.parse(f.get_as_text())
	f.close()
	
	if result_json.error != OK:
		print("Error Reading Ca talogfile: %s , line: %s" % [result_json.error_string, result_json.error_line])
		return
	
	var data = result_json.result
	for key in data:
		var items = data[key]
		for item in items:
			var inventory_item = InventoryItem.new()
			inventory_item.id = item["id"]
			inventory_item.name = item["name"]
			inventory_item.caption = item["caption"]
			inventory_item.type = item["type"]
			inventory_item.texture = textures[inventory_item.id]
			catalog[inventory_item.id] = inventory_item

