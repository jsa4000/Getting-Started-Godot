extends StaticBody2D

signal body_entered
signal body_exited

export var force = 0.01

var items = []

func _physics_process(delta):
	for item in items:
		if item is RigidBody2D:
			var direction = item.position - position
			item.set_linear_velocity(-direction * force * item.mass)
		else:
			var direction = item.position - position
			item.position += -direction * force

func _on_Area2D_body_entered(body):
	if !body.is_in_group("world"):
		print("Enter %s"%body)
		items.append(body)
		emit_signal("body_entered")

func _on_Area2D_body_exited(body):
	if !body.is_in_group("world"):
		print("Exited %s"%body)
		items.erase(body)
		emit_signal("body_exited")
