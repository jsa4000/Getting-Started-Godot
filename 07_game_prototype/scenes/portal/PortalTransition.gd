extends Node
class_name PortalTransition

signal transition_completed(object, key)

func is_type(type): return type == "PortalTransition" or .is_type(type)
func get_type(): return "PortalTransition"

func play():
	pass
