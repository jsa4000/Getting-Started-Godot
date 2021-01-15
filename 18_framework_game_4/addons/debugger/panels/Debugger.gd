@tool
class_name Debugger extends PanelContainer
@icon("../icons/icon.svg")

@export_placeholder var footer : String #setget _set_footer
@export var show_stats : bool = true #setget _set_show_stats
@export var show_console : bool = false #setget _set_show_console
# TODO Godot 4.0 does not allow to specify the type for the array (Resource)
# TODO Godot 4.0 does not allow the create a resource item in an array
#@export var refresh_subscriptions : Array =  []
@export var refresh_subscription : Resource

@onready var _panelList : OptionButton = $CanvasLayer/Container/Header/Menubar/PanelList
@onready var _viewport : SplitContainer = $CanvasLayer/Container/Viewport
@onready var _panel : Container = $CanvasLayer/Container/Viewport/Right
@onready var _left : SplitContainer = $CanvasLayer/Container/Viewport/Left
@onready var _stats : StatsPanel = $CanvasLayer/Container/Viewport/Left/Top/StatsPanel
@onready var _label : Label = $CanvasLayer/Container/Footer/Label
@onready var _container : Control = $CanvasLayer/Container

@onready var console : ConsolePanel = $CanvasLayer/Container/Viewport/Left/Bottom/ConsolePanel
	
var _panels : Array = []

func _ready():
	if Engine.is_editor_hint():
		return
	_init_subscriptions()
	_set_visible(visible)
	call_deferred("_initialize")
	
func _init_subscriptions():
	# TODO: Godot 4 does not allow to create resources in arrays from the editor
	var refresh_subscriptions = [refresh_subscription]
	for sub in refresh_subscriptions:
		var node = get_node(sub.node_path)
		node.connect(sub.signal_name, _on_refresh)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F12):
		_set_visible(!_container.visible)

func _on_refresh(param):
	_initialize()

func _on_List_item_selected(index):
	_change_panel(index - 1)

func _on_HideLocked_toggled(button_pressed):
	for panel in _panels:
		if panel.lock:
			panel.visible = !button_pressed
			
func _on_HideStats_toggled(button_pressed):
	_set_show_stats(button_pressed)
	
func _on_ShowConsole_toggled(button_pressed):
	_set_show_console(button_pressed)

func _initialize():
	_panels = get_tree().get_nodes_in_group(Global.DEBUG_GROUP)
	for panel in _panels:
		if !panel.lock:
			panel.get_parent().remove_child(panel)
			panel.visible = false
	_fill_list(_panels)
	_set_footer(footer)
	_set_show_stats(show_stats)
	_set_show_console(show_console)
	
func _fill_list(panels : Array):
	_panelList.clear()
	_panelList.add_item("Select item")
	for panel in panels:
		if !panel.lock:
			_panelList.add_item(panel.title)	
	
func _change_panel(index):
	for child in _panel.get_children():
		_panel.remove_child(child)
		child.visible = false
	if index >= 0:
		var panel =  _panels[index]
		_panel.add_child(panel)
		panel.visible = true
		_viewport.collapsed = false
		_panel.visible = true
	else:
		_viewport.collapsed = true
		_panel.visible = false
		
func _set_footer(value : String) -> void:
	footer = value
	if _label != null: 
		_label.text = value

func _set_show_stats(value : bool) -> void:
	show_stats = value
	if _stats != null:
		_stats.enabled = value
	
func _set_show_console(value : bool) -> void:
	show_console = value
	if console != null:
		console.enabled = value
		console.visible = value
	if _left != null:
		_left.collapsed = !value

func _set_visible(value : bool) -> void:
	_container.visible = value
