extends KinematicBody

func _ready():
	pass 

func __input(event):
	if event is InputEventScreenDrag:
		self.global_transform.origin.x += event.relative.x 
		self.global_transform.origin.z += event.relative.x 
	if event is InputEventPanGesture:
		self.global_transform.origin.x += event.delta.x
		self.global_transform.origin.z += event.delta.x

 
