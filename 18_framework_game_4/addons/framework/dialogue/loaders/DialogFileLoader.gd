class_name DialogFileLoader extends DialogLoader

const TEXTURES_EXTENSION = ".png"
const SCRIPTS_EXTENSION = ".json"

@export_global_dir var textures_path : String
@export_global_dir var scripts_path : String

func init():
	_load_textures()
	_load_scripts()

func _load_textures():
	var dir = Directory.new()
	if dir.open(textures_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if !dir.current_is_dir() && file_name.ends_with(TEXTURES_EXTENSION):
				textures[file_name.get_basename()] = ResourceLoader.load(textures_path + "/" + file_name)
			file_name = dir.get_next()

func _load_scripts():
	var dir = Directory.new()
	if dir.open(scripts_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if !dir.current_is_dir() && file_name.ends_with(SCRIPTS_EXTENSION):
				_load_script(scripts_path + "/" +  file_name)
			file_name = dir.get_next()

func _load_script(file_name):
	var f := File.new()
	f.open(file_name, File.READ)
	var result_json := JSON.parse(f.get_as_text())
	f.close()
	
	# TODO: Godot 4 does recognize error as Object instead enum (result_json.error != OK)
	if result_json.error:
		print("Error Reading Scripts file: %s , line: %s" % [result_json.error_string, result_json.error_line])
		return
	
	var script_id = file_name.get_file().get_basename()
	scripts[script_id] = {}
	var data = result_json.result
	for key in data:
		var scene = DialogScene.new()
		var items = data[key]
		for item in items:
			var scene_item = DialogSceneItem.new()
			# TODO: Godot 4.0 Access by index in dictionraies is not working
			scene_item.id = item.get("id")
			# TODO. Godot 4..0 does not allow to set SString to null
			scene_item.next = item.get("next") if item.has("next") else ""
			scene_item.type = item.get("type")
			scene_item.actor = item.get("actor")
			scene_item.status = item.get("status")
			scene_item.text = item.get("text")
			scene_item.texture = textures[scene_item.actor + "_" + scene_item.status]
			scene.items[scene_item.id] = scene_item
		scene.id = key
		scene.current = items[0].get("id")
		scene.default = items[items.size() - 1].get("id")
		scripts[script_id][key] = scene
