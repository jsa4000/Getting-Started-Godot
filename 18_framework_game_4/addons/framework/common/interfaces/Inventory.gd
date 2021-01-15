class_name Inventory extends Node

signal item_added(item)
signal item_updated(item)
signal item_removed(item)

func size() -> int: return 0

func add_item(item) -> void: pass

func get_item(id): pass

func has(id) -> bool: return false

func remove(id) -> void: pass

