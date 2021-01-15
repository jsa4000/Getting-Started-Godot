class_name InteractionPolicy extends Resource

var _parent : Node

func init(parent : Node) -> void:
	_parent = parent
	_ready()
	
func _ready() -> void: pass

func get_interaction() -> Interaction: return null

