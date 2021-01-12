tool
extends Action
class_name CrouchAction

var actor
var direction : Vector2 = Vector2.ZERO

func initialize(actor, direction := Vector2.ZERO):
	self.actor = actor
	self.direction = direction

func execute() -> void:
	if not actor:
		logger.error("No actor has been specified for Action %s" % name, self)
		return
		
	var state_machine = actor.get_component("state_machine")
	state_machine.get_state().handle(self)
	
	emit_signal("finished", self,  null)
