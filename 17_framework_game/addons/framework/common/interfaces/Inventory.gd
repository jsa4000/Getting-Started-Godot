extends Node
class_name Inventory

signal item_added(item)
signal item_updated(item)
signal item_removed(item)

func size() -> int: return 0
	
func add(item) -> void: pass

func get(id): pass

func has(id) -> bool: return false

func remove(id) -> void: pass
		
