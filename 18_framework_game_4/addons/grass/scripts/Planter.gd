class_name Planter extends MultiMeshInstance3D
@icon("../icons/grass.svg")

@export_range(0,5000)  var span : float = 5.0
@export_range(0,100000) var count : int = 5000
@export var width : Vector2 = Vector2(0.01, 0.02)
@export var height : Vector2 = Vector2(0.04, 0.08)
@export var sway_yaw : Vector2 = Vector2(0.0, 10.0)
@export var sway_pitch : Vector2 = Vector2(0.0, 10.0)

var _rng = RandomNumberGenerator.new()

func _init():
	rebuild()
	
func _ready():
	rebuild()

func rebuild():
	if not multimesh:
		multimesh = MultiMesh.new()
	_rng.randomize()
	multimesh.instance_count = 0
	multimesh.mesh = GrassFactory.create()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_custom_data = true
	multimesh.use_colors = false
	multimesh.instance_count = count
	for index in (multimesh.instance_count):
		var pos = Vector3(_rng.randf_range(-span,span), 0.0, _rng.randf_range(-span,span))
		var basis = Basis(Vector3.UP, deg2rad(_rng.randf_range(0, 359)))
		multimesh.set_instance_transform(index, Transform(basis, pos))
		multimesh.set_instance_custom_data(index, Color(
			_rng.randf_range(width.x, width.y),
			_rng.randf_range(height.x, height.y),
			deg2rad(_rng.randf_range(sway_pitch.x, sway_pitch.y)),
			deg2rad(_rng.randf_range(sway_yaw.x, sway_yaw.y))
		))

