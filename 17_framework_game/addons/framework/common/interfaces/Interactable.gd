extends Node
class_name Interactable

signal interaction_started(object)
signal interaction_finished(object)

func interact(entity: Node, parameters: Dictionary = {}) -> void: pass
