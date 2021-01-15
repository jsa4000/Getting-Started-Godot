@tool
extends ColorRect

@export_enum("None", "RuleOfThirds", "FibonacciSpiral", "GoldenRatio") var type : String = "None" #setget _set_type 
@export_range(0.0,1.0,0.000001) var transparency : float=0.5 #setget _set_transparency
@export var flip_h : bool = false #setget _set_flip_h 
@export var flip_v : bool = false #setget _set_flip_v

@onready var types = {
	"None" : null,
	"RuleOfThirds" : $RuleOfThirds,
	"FibonacciSpiral" : $FibonacciSpiral,
	"GoldenRatio" : $GoldenRatio,
}

func _ready():
	_set_type(type)
	
func _set_transparency(value : float) -> void:
	transparency = value
	modulate.a = transparency

func _set_type(value : String) -> void:
	if types.is_empty():
		return
	if types[type] != null:
		types[type].visible = false
	type = value
	if types[type] != null:
		types[type].visible = true

func _set_flip_h(value : bool) -> void:
	if types.is_empty():
		return
	flip_h = value
	for key in types:
		if types[key] != null:
			types[key].flip_h = value
		
func _set_flip_v(value : bool) -> void:
	if types.is_empty():
		return
	flip_v = value
	for key in types:
		if types[key] != null:
			types[key].flip_v = value