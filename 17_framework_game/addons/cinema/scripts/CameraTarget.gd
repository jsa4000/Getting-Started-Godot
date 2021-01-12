tool
extends MeshInstance
class_name CameraTarget, "../icons/target.svg"

const TOTAL_LAYERS := 20
const DEFAULT_VISUAL_LAYER := 10

const CameraTargetMaterial := preload("res://addons/cinema/assets/materials/camera_target.material")

export(int) var visual_layer : int = DEFAULT_VISUAL_LAYER setget _set_visual_layer

func _ready():
	_clean_visual_layers()
	_set_visual_layer(visual_layer)
	_init_mesh()
		
func _init_mesh():
	cast_shadow = false
	material_override = CameraTargetMaterial

func _clean_visual_layers():
	for i in range(TOTAL_LAYERS):
		set_layer_mask_bit(i,false)
		
func _set_visual_layer(value : int):
	set_layer_mask_bit(visual_layer,false)
	visual_layer = value
	set_layer_mask_bit(visual_layer,true)
