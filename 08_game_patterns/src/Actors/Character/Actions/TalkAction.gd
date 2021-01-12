tool
extends Action
class_name TalkAction

export(Resource) var dialogue

func execute() -> void:
	logger.debug("Action %s has been executed" % name, self)
	emit_signal("finished", self,  null)
