@tool
class_name CatalogueControl extends Control
@icon("../icons/inventory_view.svg")

enum Options {ACCEPT, EXIT}

@export var enabled : bool = false
@export var game_delegate : Resource
@export_node_path var inventory : NodePath
@export_range(0,10,0.1) var transition_speed : float = 4.0
@export var custom_font: Font

@onready var _inventory : Inventory
@onready var _container : Control = $CanvasLayer/Container
@onready var _player : AnimationPlayer = $AnimationPlayer
@onready var _item_list : ItemList = $CanvasLayer/Container/VBoxContainer/HBoxContainer/Panel/ItemList 
@onready var _options : Array = [
	$CanvasLayer/Container/VBoxContainer/Options/Accept,
	$CanvasLayer/Container/VBoxContainer/Options/Exit
	]

var _current_selection : int = 0
var _item_selection : int = 0
var _is_paused = false
var _is_game_paused = false

signal item_selected(item)

# TODO: Godot 4 error havinf this into the constructor. Adding super() does not nothing
#func _init():
#	if not visibility_changed.is_connected(_on_visibility_changed):
#		visibility_changed.connect(_on_visibility_changed)

func _ready():
	_set_pause_mode(Node.PAUSE_MODE_PROCESS)
	_set_enabled(enabled)
	_set_visible(false)
	if Engine.is_editor_hint():
		return
	_set_inventory(inventory)
	_set_selection(_current_selection)
	_init_game_delegate()
	_init_inventory()
	_set_custom_font(custom_font)
	
func _init_game_delegate():
	game_delegate.on_pause.connect(_on_pause)
	game_delegate.on_resume.connect(_on_resume)
	
func _init_inventory():
	_inventory.item_added.connect(_on_item_added)
	_inventory.item_updated.connect(_on_item_updated)
	_inventory.item_removed.connect(_on_item_removed)
	
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
		await pause(!visible)
		
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
		await _execute_selection(_current_selection)
	
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
		# TODO: Godot 4 error with await functions
		#await _player.animation_finished
		_set_visible(enable)

func _set_inventory(value: NodePath):
	if not value.is_empty():
		_inventory = get_node(value)

func _set_visible(value : bool) -> void:
	_container.visible = value
	visible = value

func _set_enabled(value : bool) -> void:
	_enable_process(value)

func _enable_process(enable : bool) -> void:
	if Engine.is_editor_hint():
		enable = false
	set_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)

func _on_visibility_changed():
	_set_visible(visible)

func _execute_selection(index : int) -> void:
	# TODO: Godot 4 issue using select statements
#	match index:
#		Options.ACCEPT:
#			if _item_list.get_item_count() > 0:
#				item_selected.emit(_inventory.get(_item_list.get_item_metadata(_item_selection)))
#			await pause(false)
#		Options.EXIT:
#			await pause(false)
	if index == int(Options.ACCEPT):
		if _item_list.get_item_count() > 0:
			item_selected.emit(_inventory.get(_item_list.get_item_metadata(_item_selection)))
		await pause(false)
	elif index == int(Options.EXIT):
		await pause(false)

func _set_pause_mode(mode : int):
	pause_mode = mode

func _set_custom_font(value : Font) -> void:
	for i in range(_options.size()):
		_options[i].set("custom_fonts/font",custom_font)

func _set_selection(index : int) -> void:
	for i in range(_options.size()):
		if i == index:
			_options[i].set("custom_font_sizes/font_size",40)
			_options[i].set("custom_constants/outline_size",1)
		else:
			_options[i].set("custom_font_sizes/font_size",25)
			_options[i].set("custom_constants/outline_size",0)

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
