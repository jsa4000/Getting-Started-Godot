extends KinematicBody

export (int) var speed = 4
export (int) var jump_speed = 15
export (int) var gravity = -40

var velocity = Vector3.ZERO

# https://cc0textures.com/view?id=PavingStones070
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		$AnimatedSprite3D.flip_h = false
		$AnimatedSprite3D.play("run")
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		$AnimatedSprite3D.flip_h = true
		$AnimatedSprite3D.play("run")
	else:
		$AnimatedSprite3D.play("idle")

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = jump_speed
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite3D.play("crouch")
	else:
		if velocity.y < 0:
			$AnimatedSprite3D.play("jumpDown")
		elif velocity.y > 0:
			$AnimatedSprite3D.play("jumpDown")
			#$AnimatedSprite3D.play("jumpUp")
