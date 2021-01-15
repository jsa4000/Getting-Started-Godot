class_name SceneLoaderMock extends SceneLoader

@onready var items : ItemList = get_node("../Container/ItemList")

func load_scene(path : String, show_loading : bool = false) -> void:
	if items != null:
		items.add_item(path)
	self.scene_loaded.emit(null)
