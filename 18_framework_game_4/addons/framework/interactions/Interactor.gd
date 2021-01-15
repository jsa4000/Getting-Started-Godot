@tool
class_name Interactor extends Interactable
@icon("../icons/interactor.svg")

@export_node_path var sonar : NodePath
@export_range(0,100,0.1) var max_distance : float = 2.0

var _sonar : Node

func _init():
	add_to_group(Interactions.INTERACTOR_GROUP)

func _ready():
	_set_sonar(sonar)
	
func get_target() -> Node3D:
	var interactable_objects = _sonar.get_objects_by_distance(max_distance)
	if interactable_objects.is_empty():
		return null
	return Types.get_object(interactable_objects[0], Node3D) as Node3D

func interact(entity: Node, params : Dictionary = {}) -> void:
	var interactable_objects = _sonar.get_objects_by_distance(max_distance)
	if interactable_objects.is_empty():
		self.interaction_finished.emit(self)
		return
	var object = Types.get_object(interactable_objects[0], Interactive)
	if object != null:
		self.interaction_started.emit(self)
		object.interaction_finished.connect(_on_interaction_finished)
		object.interact(entity, params)
	else:
		self.interaction_finished.emit(self)

func _on_interaction_finished(object):
	object.interaction_finished.disconnect(_on_interaction_finished)	
	self.interaction_finished.emit(self)

func _set_sonar(value: NodePath) -> void:
	if not value.is_empty():
		_sonar = get_node(value)
