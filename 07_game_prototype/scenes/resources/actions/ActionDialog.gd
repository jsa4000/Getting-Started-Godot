tool
extends Action
class_name ActionDialog

const DEFAULT_TARGET_GROUP = "Player"

export(Resource) var scene = DialogScene.new()

func _init():
	type = Type.DIALOG
	target_group = DEFAULT_TARGET_GROUP
	
func _execute(actor):
	scene = _get_scene_or_default()
	DialogManager.control.open(scene)
	yield(DialogManager.control, "control_closed")
	emit_signal("action_finished", self)

func _get_scene_or_default():
	if not scene:
		return  DialogScene.new()
	if not scene.id:
		return DialogManager.scenes[id]
	return scene
