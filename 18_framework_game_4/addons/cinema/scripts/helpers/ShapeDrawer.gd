class_name ShapeDrawer extends Control

var colors : Array = []
var rects : Array = []

func _ready(): 
	update()
	
func _physics_process(delta):
	update()
	
func _draw(): 
	if rects.is_empty():
		return
		
	for i in range(rects.size()): 
		draw_rect(rects[i],colors[i]) 

func clear() -> void:
	rects.clear()
	colors.clear()

func append(rect: Rect2, color: Color) -> void:
	rects.append(rect)
	colors.append(color)



