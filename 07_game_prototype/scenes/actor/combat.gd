extends Spatial

const DamageScene = preload("res://scenes/actor/Damage.tscn")

var combat_mode : bool =  false setget set_combat_mode
var mouse_offset : float = 0.0
var delta_gesture : Vector2

onready var ray_cast : Spatial = $Spatial/RayCast

signal attacked(actor, target)
signal combat_mode_changed(actor, enabled)

func set_combat_mode(newVal):
	combat_mode = newVal
	_show_controls(combat_mode)
	
func _ready():
	ray_cast.enabled = true

func _input(event):
	if event.is_action_pressed("combat") && not combat_mode:
		self.combat_mode = true
		emit_signal("combat_mode_changed", self, self.combat_mode)
	if event.is_action_released("combat"):
		self.combat_mode = false
		emit_signal("combat_mode_changed", self, self.combat_mode)
		
	if not combat_mode:
		return

	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT and event.pressed && ray_cast.is_colliding():
		create_partciles(ray_cast.get_collider() as Spatial, ray_cast.get_collision_point())
	if event is InputEventPanGesture:
		var gesture = event as InputEventPanGesture
		delta_gesture = gesture.delta
		#print(delta_gesture)

func create_partciles(node: Spatial, position: Vector3):
		var collider = node
		var damage = DamageScene.instance()
		collider.add_child(damage)
		damage.global_transform.origin = position
		yield(get_tree().create_timer(2),"timeout")
		damage.queue_free()

func _process(delta):		
	if not combat_mode:
		return
	
	self.rotation.y = -_get_mouse_angle() + mouse_offset
	#self.rotation.z = delta_gesture.y
	
func _show_controls(show):
	if combat_mode: 
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		show()
	else:  
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		hide()
		
func _get_mouse_angle() -> float:
	var screen_pos = get_viewport().get_camera().unproject_position(self.global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	return screen_pos.angle_to_point(mouse_pos)
