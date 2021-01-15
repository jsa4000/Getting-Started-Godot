class_name InteractionRandomPolicy extends InteractionPolicy

@export_range(0,9999) var seed_number : int = 0

var _random = RandomNumberGenerator.new()

func _ready():
	_random.seed = seed_number

func get_interaction() -> Interaction:
	if _parent.get_child_count() == 0:
		return null
	return _parent.get_child(_random.randi_range(0, _parent.get_child_count() - 1)) as Interaction

