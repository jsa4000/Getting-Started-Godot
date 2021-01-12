extends Actor
class_name Player

export (float) var max_running_speed = 3.0
export (float) var max_walking_speed = 1.5
export (float) var acceleration = 1.3
export (float) var friction = 4.0
export (float) var jump_speed = 10.0
export (float) var gravity = -40.0

var tapRightLeft = [0, 0]
var is_running = false
var can_move = true
var combat_mode = false

func _ready():
	add_to_group("Player")
	InventoryManager.control.set_inventory(inventory)

func interact(resource, action):
	action.connect("action_finished", self, "_on_action_finished")
	action.execute(self)
	can_move = false
	yield(action,"action_finished")
	can_move = true

func _physics_process(delta):
	_set_menu_state()
	
	if not can_move || combat_mode:
		return
		
	var input_direction = _get_input_direction()
	_set_input_state(input_direction)
	
	if input_direction != Vector3.ZERO:
		var max_speed = max_walking_speed
		if is_running:
			max_speed = max_running_speed
		velocity += input_direction * acceleration * delta
		if velocity.length() >= max_speed:
			velocity = input_direction * max_speed
	else:
		 velocity = lerp(velocity, Vector3.ZERO, friction * delta) 
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)

func _set_menu_state():
	if Input.is_action_pressed("menu") && not InventoryManager.control.is_visible():
		InventoryManager.control.open(self.global_transform.origin)
		can_move = false
	if Input.is_action_just_released("menu"):
		InventoryManager.control.close()
		can_move = true

func _set_input_state(input_direction):
	if !input_direction:
		$AnimatedSprite3D.play("idle")
		is_running = false
	if Input.is_action_just_pressed("ui_accept"):
		$AnimatedSprite3D.play("idle")
		is_running = false
		emit_signal("interaction_requested", self)
		return
	if Input.is_action_just_pressed("move_right") && tapRightLeft[0] < 2:
		$AnimatedSprite3D.flip_h = true
		$AnimatedSprite3D.play("walk")
		tapRightLeft[0] += 1
		yield(get_tree().create_timer(.3),"timeout")
		tapRightLeft[0] = 0
	if Input.is_action_pressed("move_right") && tapRightLeft[0] >= 2:
		$AnimatedSprite3D.play("run")
		is_running = true
	if Input.is_action_just_pressed("move_left") && tapRightLeft[1] < 2:
		$AnimatedSprite3D.flip_h = false
		$AnimatedSprite3D.play("walk")
		tapRightLeft[1] += 1
		yield(get_tree().create_timer(.3),"timeout")
		tapRightLeft[1] = 0
	if Input.is_action_pressed("move_left") && tapRightLeft[1] >= 2:
		$AnimatedSprite3D.play("run")
		is_running = true

func _get_input_direction() -> Vector3:
	var input_direction = Vector3.ZERO
	input_direction.x = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))
	input_direction.z = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction.normalized()


func _on_Combat_combat_mode_changed(actor, enabled):
	self.combat_mode = enabled
