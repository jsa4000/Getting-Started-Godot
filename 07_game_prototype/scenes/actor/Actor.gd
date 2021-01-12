extends KinematicBody
class_name Actor

var velocity = Vector3.ZERO
var inventory = Inventory.new()

signal interaction_requested(actor)

func interact(resource, action):
	pass

func direction() -> Vector3: 
	return velocity.normalized()

func _ready():
	add_to_group("Actor")
