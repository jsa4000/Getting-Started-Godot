extends Resource

export (int) var id = -1
export (float) var footprint = 10.0
export (float) var density = 1.0
export (float) var max_density = 1.0
export (Color) var color = Color(0, 0, 0)
export (Mesh) var mesh = null
export (Mesh) var mesh1 = null
export (Mesh) var mesh2 = null
export (Shape) var shape = null
export (bool) var cast_shadow = false
export (Vector3) var scale = Vector3(1.0, 1.0, 1.0)
export (float) var scale_variation = 0.0
export (bool) var fill_pass = false
export (bool) var enabled = true
export (float) var lod1_density_scale = 1.0
export (float) var lod2_density_scale = 1.0

static func compare_by_footprint(a, b):
	return a.footprint < b.footprint


func _to_string():
	return "{ID=%s footprint=%s density=%s}" % [id, footprint, density]
