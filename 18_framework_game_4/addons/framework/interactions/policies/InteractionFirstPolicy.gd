class_name InteractionFirstPolicy extends InteractionPolicy

func get_interaction() -> Interaction: 
	if _parent.get_child_count() == 0:
		return null
	return _parent.get_child(0) as Interaction

