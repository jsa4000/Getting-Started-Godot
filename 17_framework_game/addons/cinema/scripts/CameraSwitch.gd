tool
extends Area
class_name CameraSwitch, "../icons/switch.svg"

const TOTAL_LAYERS := 20
const DEFAULT_LAYER_MASK := 10

export(bool) var enabled : bool = true setget _set_enabled
export(int) var layer_mask : int = DEFAULT_LAYER_MASK setget _set_layer_mask
export(NodePath) var camera_entered : NodePath
export(NodePath) var camera_exited : NodePath
export(Resource) var callback_entered : Resource setget _set_callback_entered
export(Resource) var callback_exited : Resource setget _set_callback_exited

var _camera_entered : Camera
var _camera_exited : Camera

func _ready():
	_clean_layer_masks()
	_set_layer_mask(layer_mask)
	_init_cameras()
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
	
func _connect() -> void:
	if is_connected ("body_entered",self,"_on_body_entered"):
		return
	connect("body_entered",self,"_on_body_entered")
	connect("body_exited",self,"_on_body_exited")
	
func _disconnect() -> void:
	if not is_connected ("body_entered",self,"_on_body_entered"):
		return
	disconnect("body_entered",self,"_on_body_entered")
	disconnect("body_exited",self,"_on_body_exited")

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
