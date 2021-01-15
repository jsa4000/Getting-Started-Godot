class_name DialogSceneItem extends Resource

enum Type {STANDARD, CHOICABLE}

@export_placeholder var id : String
@export_placeholder var next : String
# TODO: Godot 4.0 documentation specifies is possible to assign custom type (Type) but an error is thrown
# TODO: Godot 4.0 Changed to type string because error in the deserialization from json
#@export var type : int = Type.STANDARD
@export_placeholder var type : String
@export_placeholder var actor : String
@export_placeholder var status : String
@export_placeholder var text : String
# TODO: Godot 4 does not allow to explicity set the type
@export var choices : Array

var texture : Texture
