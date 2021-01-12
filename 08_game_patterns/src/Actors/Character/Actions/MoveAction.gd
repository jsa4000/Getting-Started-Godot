tool
extends Action
class_name MoveAction

enum Mode { IDLE, WALK, RUN, CROUCH, JUMP }

var actor
var direction : Vector2 = Vector2.ZERO
var mode =  Mode.IDLE

var index = 0
 
func initialize(actor, mode := Mode.IDLE, direction := Vector2.ZERO):
	self.actor = actor
	self.mode = mode
	self.direction = direction

func execute() -> void:
	if not actor:
		logger.error("No actor has been specified for Action %s" % name, self)
		return
		
	if Mode.IDLE: direction.x = 0
	var state_machine = actor.get_component("state_machine")
	state_machine.get_state().handle(self)
	
	emit_signal("finished", self,  null)
