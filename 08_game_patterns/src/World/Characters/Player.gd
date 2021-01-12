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

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		controller.get_executor().is_deferred_enabled = true
		_process_batch(delta)
	_handle_input(delta)

func _handle_input(delta):
	var action : Action
	var direction =  _get_input_direction()
	if Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("shift"):
			action = controller.get_action("MoveAction") as MoveAction
			action.initialize(actor, MoveAction.Mode.RUN, direction)
			controller.handle(action)
		else:
			action = controller.get_action("MoveAction") as MoveAction
			action.initialize(actor, MoveAction.Mode.WALK, direction)
			controller.handle(action)
		
	if Input.is_action_pressed("move_left"): 
		if Input.is_action_pressed("shift"):
			action = controller.get_action("MoveAction") as MoveAction
			action.initialize(actor, MoveAction.Mode.RUN, direction)
			controller.handle(action)
		else:
			action = controller.get_action("MoveAction") as MoveAction
			action.initialize(actor, MoveAction.Mode.WALK, direction)
			controller.handle(action)
		
	if Input.is_action_pressed("move_down"):	
		action = controller.get_action("MoveAction") as MoveAction
		action.initialize(actor, MoveAction.Mode.CROUCH, direction)
		controller.handle(action)
		
	if Input.is_action_just_pressed("move_up"):	
		action = controller.get_action("MoveAction") as MoveAction
		action.initialize(actor, MoveAction.Mode.JUMP, direction)
		controller.handle(action)
	
	if not action:
		action = controller.get_action("MoveAction") as MoveAction
		action.initialize(actor)
		controller.handle(action)	

func _process_batch(delta):
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
	
	for i in range(20):
		action = controller.get_action("MoveAction").duplicate()
		action.initialize(actor, MoveAction.Mode.WALK, Vector2(-1,0))
		controller.handle(action)

	action = controller.get_action("MoveAction").duplicate()
	action.initialize(actor)
	controller.handle(action)
	
	for i in range(20):
		action = controller.get_action("MoveAction").duplicate()
		action.initialize(actor, MoveAction.Mode.JUMP, Vector2(-1,0))
		controller.handle(action)

	action = controller.get_action("MoveAction").duplicate()
	action.initialize(actor)
	controller.handle(action)

func _get_input_direction() -> Vector2:
	var input_direction = Vector2.ZERO
	input_direction.x = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction.normalized()

