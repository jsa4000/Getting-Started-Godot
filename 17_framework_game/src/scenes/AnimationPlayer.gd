extends AnimationPlayer

export(NodePath) var next_camera : NodePath

onready var _camera = get_node(next_camera)

func start(anim : String) -> void:
	play(anim)
	yield(self, "animation_finished")
	_camera.enabled = true
