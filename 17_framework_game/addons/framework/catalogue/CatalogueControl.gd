tool
extends Control
class_name CatalogueControl, "../icons/inventory_view.svg"

enum Options {ACCEPT, EXIT}

export (bool) var enabled : bool = false setget _set_enabled
export(Resource) var game_delegate : Resource
export(NodePath) var inventory : NodePath
export (float,0,10) var transition_speed : float = 4.0
export(Font) var theme_option_enabled : Font
export(Font) var theme_option_disabled : Font

onready var _inventory : Inventory = get_node(inventory)
onready var _container : Control = $CanvasLayer/Container
onready var _player : AnimationPlayer = $AnimationPlayer
onready var _item_list : ItemList = $CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/ItemList 
onready var _options : Array = [
	$CanvasLayer/Container/VBoxContainer/Options/Accept,
	$CanvasLayer/Container/VBoxContainer/Options/Exit
	]

var _current_selection : int = 0
var _item_selection : int = 0
var _is_paused = false
var _is_game_paused = false

signal item_selected(item)

func _init():
	if not is_connected("visibility_changed",self,"_on_visibility_changed"):
		connect("visibility_changed",self,"_on_visibility_changed")

func _ready():
	_set_enabled(enabled)
	_set_visible(false)
	_set_selection(_current_selection)
	_init_game_delegate()
	_init_inventory()

func _init_game_delegate():
	game_delegate.connect("pause", self, "_on_pause")
	game_delegate.connect("resume", self, "_on_resume")
	
func _init_inventory():
	_inventory.connect("item_added", self, "_on_item_added")
	_inventory.connect("item_updated", self, "_on_item_updated")
	_inventory.connect("item_removed", self, "_on_item_removed")
	
func _on_item_added(item) -> void:
	_add_item(item)

func _on_item_updated(item) -> void:
	pass

func _on_item_removed(item) -> void:
	 _remove_item(item)
			
func _on_pause(node : Node) -> void:
	if node != self:
		_is_game_paused = true

func _on_resume(node : Node) -> void:
	if node != self && _is_paused:
		game_delegate.pause(self)
	_is_game_paused = false

func _process(delta):
	if Input.is_action_just_pressed("inventory") && not _is_game_paused:
		pause(!visible)
		
	if not _is_paused:
		return
		
	if Input.is_action_just_pressed("ui_right"):
		if _current_selection < _options.size() - 1:
			_current_selection += 1
			_set_selection(_current_selection)
	elif Input.is_action_just_pressed("ui_left"):
		if _current_selection > 0:
			_current_selection -= 1
			_set_selection(_current_selection)
	elif Input.is_action_just_pressed("ui_down"):
		if _item_selection < _item_list.get_item_count() - 1:
			_item_selection += 1
			_select_item(_item_selection)
	elif Input.is_action_just_pressed("ui_up"):
		if _item_selection > 0:
			_item_selection -= 1
			_select_item(_item_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		_execute_selection(_current_selection)
	
func pause(enable : bool) -> void:
	if enable:
		_is_paused = true
		game_delegate.pause(self)
		_set_visible(enable)
		_player.play("Open",-1,4)
		_select_item(_item_selection)
	else:
		_is_paused = false
		game_delegate.resume(self)
		_player.play("Close",-1,4)
		yield(_player,"animation_finished")
		_set_visible(enable)

func _set_visible(value : bool) -> void:
	_container.visible = value
	visible = value

func _set_enabled(value : bool) -> void:
	enabled = value
	_enable_process(enabled)

func _enable_process(enable : bool) -> void:
	if Engine.is_editor_hint():
		enable = false
	set_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)

func _on_visibility_changed():
	_set_visible(visible)

func _execute_selection(index : int) -> void:
	match index:
		Options.ACCEPT:
			if _item_list.get_item_count() > 0:
				emit_signal("item_selected", _inventory.get(_item_list.get_item_metadata(_item_selection)))
			pause(false)
		Options.EXIT:
			pause(false)
			
func _set_selection(index : int) -> void:
	for i in range(_options.size()):
		if i == index:
			_options[i].set("custom_fonts/font",theme_option_enabled)
		else:
			_options[i].set("custom_fonts/font",theme_option_disabled)

func _select_item(index: int) -> void:
	for item in range(_item_list.get_item_count()):
		_item_list.set_item_custom_bg_color(item, Color.transparent)
	_item_list.select(_item_selection)
	_item_list.set_item_custom_bg_color (_item_selection, Color.gray)
	
func _add_item(item) -> void:
	var index = _item_list.get_item_count()
	_item_list.add_item(item.id, item.image)
	_item_list.set_item_metadata(index,item.id)

func _remove_item(item) -> void:
	for index in range(_item_list.get_item_count()):
		if _item_list.get_item_metadata(index) == item.id:
			_item_list.remove_item(index)
