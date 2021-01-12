extends StaticBody

export(Resource) var resource = NodeResourceInteractive.new()

onready var area_interactive = $AreaInteractive

func _ready():
	area_interactive.connect("interaction_requested", self,"_on_interaction_requested")

func _on_interaction_requested(actor):
	resource.interact(actor)
