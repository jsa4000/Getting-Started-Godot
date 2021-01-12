tool
extends EditorPlugin

const LoggerManagerPath = "res://addons/logging/auto/LoggerManager.gd"

func _enter_tree():
	add_autoload_singleton("LoggerManager", LoggerManagerPath)

func _exit_tree():
	remove_autoload_singleton("LoggerManager")
