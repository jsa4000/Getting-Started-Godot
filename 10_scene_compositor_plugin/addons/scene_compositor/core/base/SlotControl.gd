tool
extends BaseControl
class_name SlotControl

enum Align { LEFT, RIGHT }

export(bool) var hide_label: bool = false setget set_hide_label
export(String) var text_label : String setget set_text_label
export(Align) var align_label = Align.LEFT setget set_align_label
export(Vector2) var min_size_label = Vector2.ZERO setget set_min_size_label
export(int) var flags_label = SIZE_EXPAND_FILL setget set_flags_label

export(bool) var hide_control: bool = false setget set_hide_control

var _connection_type : int = -1 setget ,get_connection_type
var _slot : int = -1 setget ,get_slot
var _remotes : Array = []
var _control : BaseControl setget set_control, get_control
var _property : String  setget set_property, get_property
var _value = null

onready var _label : Label = $Label

signal value_requested(control, property_name)	

func set_hide_label(value : bool):
	hide_label = value
	if not is_inside_tree() || not _label:
		return
	if hide_label:
		_label.hide()
	else:
		_label.show()

func set_text_label(value : String):
	text_label = value
	if not is_inside_tree() || not _label:
		return
	_label.text = text_label

func set_align_label(value : int):
	align_label = value
	if not is_inside_tree() || not _label:
		return
	if align_label == Align.LEFT:
		_label.align = Label.ALIGN_LEFT
	else:
		_label.align = Label.ALIGN_RIGHT
	
func set_flags_label(value : int):
	flags_label = value
	if not is_inside_tree() || not _label:
		return
	_label.size_flags_horizontal = flags_label

func set_min_size_label(value : Vector2):
	min_size_label = value
	if not is_inside_tree() || not _label:
		return
	if min_size_label == Vector2.ZERO:
		_label.autowrap = false
	else:
		_label.autowrap = true
		_label.rect_min_size = min_size_label

func set_hide_control(value : bool):
	hide_control = value
	if not is_inside_tree() || not _control:
		return
	if hide_control:
		_control.hide()
	else:
		_control.show()

func get_control() -> BaseControl:  return _control
	
func get_property(): return _property
	
func set_property(name: String): _property = name

func get_slot() -> int:  return _slot
	
func get_connection_type() -> int:  return _connection_type

func set_control(value : BaseControl):
	if _control:
		_control.disconnect("value_changed", self, "_on_value_changed")
		remove_child(_control)
	_control = value
	if not _control:
		set_flags_label(SIZE_EXPAND_FILL)
		return
	_control.connect("value_changed", self, "_on_value_changed")
	add_child(_control)
	set_flags_label(SIZE_FILL)
	_control.size_flags_horizontal = SIZE_EXPAND_FILL

func _ready():
	set_hide_label(hide_label)
	set_text_label(text_label)
	set_align_label(align_label)
	set_flags_label(flags_label)
	set_min_size_label(min_size_label)
	set_hide_control(hide_control)

func set_slot(slot: int, connection_type: int):
	_slot = slot
	_connection_type = connection_type
	
func is_slot(slot: int, connection_type: int) -> bool:
	return _slot == slot && _connection_type == connection_type
	
func get_remote(index : int) -> SlotControl:  return _remotes[index] as SlotControl

func remove_remote(slot : SlotControl): 
	if not _remotes.has(slot):
		return
	_remotes.erase(slot)
	if _remotes.empty():
		set_hide_control(false)
	slot.disconnect("value_changed", self, "_on_value_changed")
	emit_signal("value_changed", self, get_value())

func add_remote(slot : SlotControl): 
	_remotes.append(slot)
	set_hide_control(true)
	slot.connect("value_changed", self, "_on_value_changed")
	emit_signal("value_changed", self, get_value())
	
func has_remote() -> bool: return !_remotes.empty()
	
func has_control() -> bool: return _control != null	

func initialize():
	_value = null

func get_value():
	#print("I am in get_value() on node %s with value %s" % [get_parent().title, _value])
	if has_remote():
		#print("Node %s requesting value to REMOTE %s" % [get_parent().title, _remote.get_parent().title])
		return _get_remote_value()
	elif has_control():
		#print("Node %s requesting value to CONTROL %s" % [get_parent().title, _control])
		return _control.get_value()
	elif _value != null:
		#print("Returning directly value on node %s with value %s" % [get_parent().title, _value])
		return _value	
	#print("Requesting process on node %s with value %s" % [get_parent().title, _value])
	emit_signal("value_requested", self, _property)
	return null
	
func set_value(value): 	
	#print("I am in set_value() on node %s with value %s" % [get_parent().title, value])
	if _value != value:
		_value = value
		emit_signal("value_changed", self, value)

func save_data() -> Dictionary: 
	var data = {
		"slot": _slot,
		"connection_type": _connection_type
	}
	if _control:
		data["data"] = Serializer.encode(_control.get_value()) 
	return data

func load_data(data : Dictionary): 
	if _control:
		_control.call_deferred("set_value", Serializer.decode(data["data"]))

func _on_value_changed(control, value):
	#print("Value changed on slot %s, connection: %s" % [name, _connection_type])
	emit_signal("value_changed", self, get_value())

func _get_remote_value():
	if _remotes.size() == 1:
		return _remotes[0].get_value()
	elif _remotes.size() > 1:
		var values = []
		for r in _remotes:
			values.append(r.get_value())
		return values
	return null
