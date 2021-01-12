class_name ProjectionUtils

const MAX_INT :=  9223372036854775807
const AABB_ENDPOINTS_COUNT := 8

static func get_aabb_projection(mesh : MeshInstance, camera : Camera) -> Rect2:
	var points = get_aabb_from_mesh(mesh)
	var projections = get_camera_projections(points, camera)
	return get_rect_from_projection(projections)

static func get_aabb_from_mesh(mesh : MeshInstance) -> Array:
	var vertices = []
	for i in range(AABB_ENDPOINTS_COUNT):
		vertices.append((mesh.get_aabb().get_endpoint(i) * mesh.scale) + mesh.global_transform.origin)
	return vertices

static func get_camera_projections(vertices : Array, camera : Camera) -> Array:
	var points = []
	for vertex in vertices:
		points.append(camera.unproject_position(vertex))
	return points
	
static func get_rect_from_projection(points : Array) -> Rect2:
	var position : Vector2 = Vector2(MAX_INT,MAX_INT)
	var end : Vector2 = Vector2(-1, -1)
	for point in points:
		if point.x < position.x:
			position.x = point.x
		if point.y < position.y:
			position.y = point.y
		if point.x > end.x:
			end.x = point.x
		if point.y > end.y:
			end.y = point.y
	return Rect2(position, Vector2(end.x - position.x, end.y - position.y))
	
static func array_to_string(name: String, array : Array):
	var string = PoolStringArray()
	for item in array:
		string.append("%s" % item)
	return "%s: %s" % [name, string.join(";")]
