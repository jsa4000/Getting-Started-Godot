extends Resource
class_name DialogSceneItem

enum Type {STANDARD, CHOICABLE}

export(String) var id
export(String) var next
export(Type) var type = Type.STANDARD
export(String) var actor
export(String) var status
export(String) var text
export(Array, String) var options

var texture : Texture
