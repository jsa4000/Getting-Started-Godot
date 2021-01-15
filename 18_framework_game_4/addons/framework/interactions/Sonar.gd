@tool
class_name Sonar extends Area3D
@icon("../icons/icon_radar.svg")

var CONNECTED_SIGNALS := [self.area_entered, self.area_exited, self.body_entered, self.body_exited]
var COLLISION_RAY_BIT_MASK : int = BIT(0) | BIT(Interactions.INTERACTIVE_LAYER_MASK)

# TODO: Godot 4 does not allow to set properties for export variables: _set_radius, _set_angle, etc..
@export var enabled : bool = true
@export_range(0,10,0.1) var height : float = 1.6 
@export var debug_enabled : bool = false

var _collision_shape : CollisionShape3D
var _drawer : RadarDrawer

var objects : Dictionary = {}

func _init():
	add_to_group(Interactions.SONAR_GROUP)

func _ready() -> void:
	_clean_layer_masks()
	_set_layers_mask(Interactions.INTERACTIVE_LAYER_MASK)
	_collision_shape = _find_collision_shape()
	_init_drawer()
	_set_enabled(enabled)
	_set_debug_enabled(debug_enabled)
	_update_area()
	
func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	if debug_enabled:
		_draw_radar()

func get_objects_by_distance(max_distance : float = -1.0) -> Array:
	var result = []
	var visible_objects = _get_visible_objects(objects)
	for item in visible_objects:
		# Godot 4.0 does not support accesing to ddictionaries via indexes
		#if max_distance == -1 || item.distance < max_distance:
		#	result.append(item.object)
		if max_distance == -1 || item.get("distance") < max_distance:
			result.append(item.get("object"))
	return result
			
func _init_drawer() -> void:
		_drawer = RadarDrawer.new()
		add_child(_drawer)	
			
func _set_enabled(value : bool) -> void:
	enabled = value
	_connect_events(enabled)
	if _collision_shape != null:
		_collision_shape.disabled != value

func _set_debug_enabled(value: bool) -> void:
	debug_enabled = value
	_enable_process(debug_enabled)
	if _drawer != null:
		_drawer.visible = debug_enabled

func _set_height(value: float) -> void:
	height = value
	_update_area()

func _clean_layer_masks() -> void:
	for i in range(Interactions.TOTAL_LAYERS):
		set_collision_layer_bit(i,false)
		set_collision_mask_bit(i,false)

func _set_layers_mask(value : int) -> void:
	set_collision_mask_bit(value, true)	

func _on_area_entered(area) -> void:
	objects[area.name] = area

func _on_area_exited(area) -> void:
	objects.erase(area.name)
	
func _on_body_entered(body) -> void:
	objects[body.name] = body

func _on_body_exited(body) -> void:
	objects.erase(body.name)

func _update_area() -> void:
	if _collision_shape != null:
		_collision_shape.translation.y = height

# TOOO Godot 4.0 issue overriding add_child and remove_child
#func add_child (node : Node, legible_unique_name : bool = false) -> void:
#	super(node, legible_unique_name)
#	if node is CollisionShape3D:
#		_collision_shape = node
#		_update_area()
#
#func remove_child (node : Node) -> void:
#	super(node)
#	if node is CollisionShape3D:
#		_collision_shape = _find_collision_shape()
		
func _find_collision_shape() -> CollisionShape3D:
	for child in get_children():
		if child is CollisionShape3D:
			return child
	return null

func _connect_events(enable: bool) -> void:
	for event in CONNECTED_SIGNALS:
		# TODO Goot 4.0 must return the last occurrence first [0] using rsplit
		var signal_name = ("%s" % event).rsplit("]", true, 1)[1]
		var callable = Callable(self, "_on_%s" % signal_name)
		var connected = event.is_connected(callable)
		if enable && not connected:
			event.connect(callable)
		elif not enable && connected:
			event.disconnect(callable)

func _get_position() -> Vector3:
	return global_transform.origin + Vector3(0, height, 0)

func _get_visible_objects(objects : Dictionary) -> Array:
	var results = []
	var position = _get_position()
	for name in objects:
		if _is_colliding(objects[name]):
			results.append(_get_dict_object(objects[name], (position - objects[name].global_transform.origin).length()))
	results.sort_custom(self, "sort_by_distance")
	return results

func _get_dict_object(object: Node3D, length: float) -> Dictionary:
	return {
		"object": object,
		"distance": length
	}

func _is_colliding(collider : Node3D) -> bool:
	if collider == null:
		return false
	var space_state = get_viewport().world_3d.direct_space_state 
	var collision = space_state.intersect_ray(_get_position(), collider.global_transform.origin, [self], COLLISION_RAY_BIT_MASK, true, true)
	# TODO Godot 4.0 does not alloww using inexing in dicionaries
	#if collision && collision.collider == collider:
	if collision && collision.get("collider") == collider:
		return true
	else:
		return false

func _enable_process(enable : bool) -> void:
	set_process(enable)
	set_physics_process(enable)
	
func _draw_radar() -> void:
	_drawer.clear()
	
	var position = _get_position()
	var pixel_per_meter = _drawer.zoom * _drawer.zoom_step
	
	if objects.is_empty():
		return
		
	for obj in objects:
		var relpos = objects[obj].global_transform.origin - position
		var canvaspos = (Vector2(relpos.x, relpos.z) * pixel_per_meter) + (_drawer.size * 0.5)
		_drawer.append(canvaspos, Color.red)

	for obj in _get_visible_objects(objects):
		# TODO Godot 4.0 does not alloww using inexing in dicionaries
		#var relpos = obj.object.global_transform.origin - position
		var relpos = obj.get("object").global_transform.origin - position
		var canvaspos = (Vector2(relpos.x, relpos.z) * pixel_per_meter) + (_drawer.size * 0.5)
		_drawer.append(canvaspos, Color.green)

static func sort_by_distance(a, b):
	# TODO Godot 4.0 does not alloww using inexing in dicionaries
	#if a.distance < b.distance:
	if a.get("distance") < b.get("distance"):
		return true
	return false

static func BIT(n : int) -> int:
	return 1 << n
