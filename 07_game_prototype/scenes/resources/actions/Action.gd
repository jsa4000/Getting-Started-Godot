tool
extends Resource
class_name Action

enum Type {DIALOG, ITEM, JUMP, USE, UNKNOWN}

export(String) var id
export(String) var target_group
export(Type) var type = Type.UNKNOWN
export(Dictionary) var parameters 

signal action_started(actor, action)
signal action_finished(action)
	
# _execute must be overrided and throw the error when it finishes
func _execute(actor):
	emit_signal("action_finished", self)

func execute(actor):
	emit_signal("action_started", actor, self)
	_execute(actor)
	
