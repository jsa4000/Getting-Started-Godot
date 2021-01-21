@tool
class_name CameraSwitch extends Area3D
@icon("../icons/switch.svg")

const TOTAL_LAYERS := 20
const DEFAULT_LAYER_MASK := 10

@export var enabled : bool = true #setget _set_enabled
@export var layer_mask : int = DEFAULT_LAYER_MASK #setget _set_layer_mask
@export_node_path var camera_entered : NodePath
@export_node_path var camera_exited : NodePath
@export var callback_entered : Resource #setget _set_callback_entered
@export var callback_exited : Resource #setget _set_callback_exited

var _camera_entered : Camera3D
var _camera_exited : Camera3D

func _ready():
	_clean_layer_masks()
	_set_layer_mask(layer_mask)
	if Engine.is_editor_hint():
		return
	_init_cameras()
	_init_callbacks()
	_set_enabled(enabled)

func _clean_layer_masks() -> void:
	for i in range(TOTAL_LAYERS):
		set_collision_layer_bit(i,false)
		set_collision_mask_bit(i,false)
		
func _set_enabled(value: bool) -> void:
	enabled = value
	if enabled && not Engine.is_editor_hint():
		_connect()
	else:
		_disconnect()
			
func _init_cameras() -> void:
	_camera_entered = get_node_or_null(camera_entered)
	_camera_exited = get_node_or_null(camera_exited)
	
func _init_callbacks() -> void:
	_set_callback_entered(callback_entered)
	_set_callback_exited(callback_exited)
	
func _connect() -> void:
	if self.body_entered.is_connected(_on_body_entered):
		return
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	
func _disconnect() -> void:
	if not self.body_entered.is_connected(_on_body_entered):
		return
	self.body_entered.disconnect(_on_body_entered)
	self.body_exited.disconnect(_on_body_exited)

func _on_body_entered(body) -> void:
	if callback_entered != null:
		callback_entered.invoke()
	if _camera_entered != null:
		_camera_entered.enabled = true

func _on_body_exited(body) -> void:
	if callback_exited != null:
		callback_exited.invoke()	
	if _camera_exited != null:
		_camera_exited.enabled = true

func _set_layer_mask(value : int):
	set_collision_mask_bit(layer_mask,false)
	layer_mask = value
	set_collision_mask_bit(layer_mask,true)

func _set_callback_entered(value : Resource) -> void:
	callback_entered = value
	if callback_entered != null && not Engine.is_editor_hint():
		callback_entered.init(self)
		
func _set_callback_exited(value : Resource) -> void:
	callback_exited = value
	if callback_exited != null && not Engine.is_editor_hint():
		callback_exited.init(self)
