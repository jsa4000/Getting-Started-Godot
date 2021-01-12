extends Interactable
class_name Interactor, "../icons/interactor.svg"

export(NodePath) var sonar : NodePath
export(float,0,100,0.1) var max_distance : float = 2.0

onready var _sonar : Node = get_node(sonar)

func _init():
	add_to_group(Interactions.INTERACTOR_GROUP)

func get_target() -> Spatial:
	var interactable_objects = _sonar.get_objects_by_distance(max_distance)
	if interactable_objects.empty():
		return null
	return Types.get_object(interactable_objects[0], Spatial) as Spatial

func interact(entity: Node, params : Dictionary = {}) -> void:
	var interactable_objects = _sonar.get_objects_by_distance(max_distance)
	if interactable_objects.empty():
		emit_signal("interaction_finished", self)
		return
	var object = Types.get_object(interactable_objects[0], Interactive)
	if object != null:
		emit_signal("interaction_started", self)
		object.connect("interaction_finished", self, "_on_interaction_finished")
		object.interact(entity, params)
	else:
		emit_signal("interaction_finished", self)

func _on_interaction_finished(object):
	object.disconnect("interaction_finished", self, "_on_interaction_finished")
	emit_signal("interaction_finished", self)
