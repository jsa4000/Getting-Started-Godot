extends Spatial

onready var environment = $Sky
onready var light1 = $Lights/OmniLight
onready var light2 = $Lights/OmniLight2

func _ready():
	pass 
	
var offset = 0.5
var step = 0.0005

func _process(delta):
	if environment != null:
		environment.time_of_day_setup = offset
		offset += step
		if offset > 1.0:
			offset = 0.0
	
	var light_enabled = false if offset < 0.75 && offset > 0.37 else true	
	if light1 != null:
		light1.visible = light_enabled
	if light2 != null:
		light2.visible = light_enabled

