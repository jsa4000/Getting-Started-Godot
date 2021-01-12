extends KinematicBody2D

export (int) var speed = 600
export (int) var jump_speed = -900
export (int) var gravity = 2000

var velocity = Vector2.ZERO

onready var anim = get_node("AnimationPlayer")

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		#get_node("States/run").set_flip_h(false)
		#get_node("States/idle").set_flip_h(false)
		#get_node("States/jump").set_flip_h(false)
		get_node("States").scale = Vector2(1, 1)
		anim.play("run", 0, 1)
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		#get_node("States/run").set_flip_h(true)
		#get_node("States/idle").set_flip_h(true)
		#get_node("States/jump").set_flip_h(true)
		get_node("States").scale = Vector2(-1, 1)
		anim.play("run", 0, 1)
	else:
		anim.play("idle", 0, 1)
		
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
			
	if velocity.y > 0:
		anim.play("jump_down", 0, 1)
	elif velocity.y < 0:
		anim.play("jump_up", 0, 1)
