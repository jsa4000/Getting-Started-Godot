extends Node

const TEXTURES_PATH = "res://assets/dialog/actors/"
const SCENES_PATH = "res://assets/dialog/scenes/"
const TEXTURES_EXTENSION = ".png"
const SCENES_EXTENSION = ".json"

onready var control : DialogControl setget set_control
onready var textures : Dictionary
onready var scenes : Dictionary

func set_control(newVal): 
	control = newVal

func _ready():
	_load_textures()
	_load_scenes()
	
	print("Sucessfully Loaded %s textures" % textures.size())
	print("Sucessfully Loaded %s scenes" % scenes.size())

func _load_textures():
	var dir = Directory.new()
	if dir.open(TEXTURES_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if !dir.current_is_dir() && file_name.ends_with(TEXTURES_EXTENSION):
				textures[file_name.get_basename()] = ResourceLoader.load(TEXTURES_PATH + file_name)
			file_name = dir.get_next()

func _load_scenes():
	var dir = Directory.new()
	if dir.open(SCENES_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if !dir.current_is_dir() && file_name.ends_with(SCENES_EXTENSION):
				_load_json(SCENES_PATH + file_name)
			file_name = dir.get_next()

func _load_json(file_name):
	var f := File.new()
	f.open(file_name, File.READ)
	var result_json := JSON.parse(f.get_as_text())
	f.close()
	
	if result_json.error != OK:
		print("Error Reading Scenes file: %s , line: %s" % [result_json.error_string, result_json.error_line])
		return
	
	var data = result_json.result
	for key in data:
		var scene = DialogScene.new()
		var items = data[key]
		for item in items:
			var scene_item = DialogSceneItem.new()
			scene_item.id = item["id"]
			scene_item.next = item["next"] if item.has("next") else null
			scene_item.type = item["type"]
			scene_item.actor = item["actor"]
			scene_item.status = item["status"]
			scene_item.text = item["text"]
			scene_item.texture = textures[item.actor + "_" + item.status]
			scene.items[scene_item.id] = scene_item
		scene.id = key
		scene.current = items[0]["id"]
		scene.default = items[items.size() - 1]["id"]
		scenes[key] = scene
