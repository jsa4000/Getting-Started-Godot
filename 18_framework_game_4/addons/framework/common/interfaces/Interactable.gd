class_name Interactable extends Node

signal interaction_started(object)
signal interaction_finished(object)

func interact(entity: Node, parameters: Dictionary = {}) -> void: pass
