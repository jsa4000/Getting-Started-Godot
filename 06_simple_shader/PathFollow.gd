extends PathFollow

func _ready():
	offset = 0

func _physics_process(delta):
	offset += delta

