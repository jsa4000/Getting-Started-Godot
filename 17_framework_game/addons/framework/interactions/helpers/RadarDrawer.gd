extends Control
class_name RadarDrawer

const DEFAULT_BACKGROUND_COLOR = Color(0,0,0,0.3)
const DEFAULT_SIZE = Vector2(250,250)

export(Color) var background_color : Color = DEFAULT_BACKGROUND_COLOR
export(Vector2) var size : Vector2 = DEFAULT_SIZE setget _set_size
export(float,0,2,0.1) var zoom : float = 1.0 setget _set_zoom
export(int,0,100) var zoom_step : float = 50 setget _set_zoom_step

var colors : Array = []
var points : Array = []

func _ready(): 
	_set_size(size)
	_set_zoom(zoom)
	_set_zoom_step(zoom_step)
	update()

func _physics_process(delta):
	update()

func _draw(): 
	_draw_background()
	_draw_radar()
	
	var pixel_per_meter = zoom * zoom_step
	for i in range(points.size()): 
		draw_circle_arc_poly(points[i], (0.2 * pixel_per_meter) * 0.5 ,colors[i]) 
		
func clear() -> void:
	points.clear()
	colors.clear()

func append(point: Vector2, color: Color) -> void:
	points.append(point)
	colors.append(color)

func _draw_background() -> void:
	draw_rect(Rect2(Vector2(0,0),size),background_color) 

func _draw_radar() -> void:
	var center = size * 0.5
	var pixel_per_meter = zoom * zoom_step
	var lines = floor( (size.x if size.x < size.y else size.y) / pixel_per_meter)
	for i in range(lines):
		draw_circle_arc(center, (i * pixel_per_meter) * 0.5)
	draw_circle_arc_poly(center, (0.25 * pixel_per_meter) * 0.5)
	draw_line(Vector2(0, size.y * 0.5), Vector2(size.x, size.y * 0.5), Color.white)
	draw_line(Vector2(size.x * 0.5, 0), Vector2(size.x * 0.5, size.y), Color.white)

func draw_circle_arc(center: Vector2, radius : float, color : Color = Color.white, angle_from : int = 0, angle_to : int = 360) -> void:
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func draw_circle_arc_poly(center: Vector2, radius : float, color : Color = Color.white, angle_from : int = 0, angle_to : int = 360) -> void:
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	draw_polygon(points_arc, colors)

func _set_size(value : Vector2) -> void:
	size = value
	rect_size = size
	_update_margins()
	update()
	
func _set_zoom(value : float) -> void:
	zoom = value
	update()
	
func _set_zoom_step(value : float) -> void:
	zoom_step = value
	update()
	
func _update_margins() -> void:
	var viewport_size = get_viewport().size
	margin_left = viewport_size.x - rect_size.x
	margin_right = 0
	margin_top = viewport_size.y - rect_size.y
	margin_bottom = 0

