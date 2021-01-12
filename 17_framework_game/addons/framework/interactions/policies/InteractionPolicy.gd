extends Resource
class_name InteractionPolicy

var _parent : Node

func init(parent : Node) -> void:
	_parent = parent
	_ready()
	
func _ready() -> void: pass

func get_interaction() -> Interaction: return null

