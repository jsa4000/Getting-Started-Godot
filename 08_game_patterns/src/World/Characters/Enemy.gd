extends KinematicBody2D	

onready var logger : Logger = ServiceLocator.get_logger()

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var actor : Actor = $Actor

var controller : Controller
var state_machine : StateMachine

func _ready():
	controller = actor.get_component("controller")
	state_machine = actor.get_component("state_machine")
	state_machine.initial_state = "IdleState"
	state_machine._set_initial_state()
	controller.get_executor().is_deferred_enabled = true

func _physics_process(delta):
	pass

func _create_movement():
	var action : Action

	action = controller.get_action("MoveAction").duplicate()
	action.initialize(actor)
	controller.handle(action)
	
	for i in range(20):
		action = controller.get_action("MoveAction").duplicate()
		action.initialize(actor, MoveAction.Mode.WALK, Vector2(1,0))
		controller.handle(action)
		
	action = controller.get_action("MoveAction").duplicate()
	action.initialize(actor)
	controller.handle(action)
	
	for i in range(30):
		action = controller.get_action("MoveAction").duplicate()
		action.initialize(actor, MoveAction.Mode.WALK, Vector2(-1,0))
		controller.handle(action)

func _on_Timer_timeout():
	_create_movement()
