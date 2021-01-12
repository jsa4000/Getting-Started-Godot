extends VisibilityNotifier

export (Resource) var biome_resource = null
export (Vector2) var chunk_size = Vector2(10, 10)
export (Vector2) var chunk_position = Vector2(0, 0)
export (Transform) var terrain_inv_transform
export (Vector2) var terrain_size = Vector2(1, 1)
export (Vector2) var terrain_pivot = Vector2(0.5, 0.5)
export (int) var lod = 0
export (bool) var enabled = true
export (float) var aabb_margin = 1.0
export (bool) var enable_shadow_proxy = false

enum MESH_RENDER { Multimesh, Particles, Particles_GPU_density }
export (MESH_RENDER) var mesh_renderer = MESH_RENDER.Multimesh

var terrain: Node = null

var _visibility_height_range = 400
var _biomes_subsets = []
const BiomeSubsetParticlesRenderer = preload("res://addons/wojtekpil.biomes/scripts/runtime/BiomeSubsetParticlesRenderer.gd")
const BiomeSubsetMultimeshRenderer = preload("res://addons/wojtekpil.biomes/scripts/runtime/BiomeSubsetMultimeshRenderer.gd")

func get_subsets():
	return _biomes_subsets

func _update_mesh_subsets(new_lod: int):
	for x in _biomes_subsets:
		x.update_lod(new_lod)

func update_lod(new_lod: int):
	if new_lod == lod:
		return
	_update_mesh_subsets(new_lod)
	lod = new_lod

func create_subset_renderer(biome_placement_node, dithering_scale, shadows):
	var subset = null
	match mesh_renderer:
		MESH_RENDER.Particles:
			subset = BiomeSubsetParticlesRenderer.new()
		MESH_RENDER.Particles_GPU_density:
			subset = BiomeSubsetParticlesRenderer.new()
			subset.gpu_compute = true
		_:
			subset = BiomeSubsetMultimeshRenderer.new()

	subset.id = biome_placement_node.id
	subset.mesh = biome_placement_node.mesh
	subset.mesh1 = biome_placement_node.mesh1
	subset.mesh2 = biome_placement_node.mesh2
	subset.shape = biome_placement_node.shape
	subset.lod = lod
	subset.lod1_density_scale = biome_placement_node.lod1_density_scale
	subset.lod2_density_scale = biome_placement_node.lod2_density_scale
	subset.chunk_size = chunk_size
	subset.chunk_position = chunk_position
	subset.stamp_size = biome_resource.biome_stamp_size
	if shadows:
		if enable_shadow_proxy:
			subset.shadows_type = subset.SHADOW_CASTING.ONLY_SHADOW
		else:
			subset.shadows_type = subset.SHADOW_CASTING.ON
	else:
		subset.shadows_type = subset.SHADOW_CASTING.OFF
	subset.densitymap = biome_resource.get_densitymap(terrain)
	subset.heightmap = biome_resource.get_heightmap(terrain)
	subset.terrain_inv_transform = terrain_inv_transform
	subset.dithering_scale = dithering_scale
	subset.object_scale = biome_placement_node.scale
	subset.object_scale_variation = biome_placement_node.scale_variation
	subset.terrain_size = terrain_size
	subset.terrain_pivot = terrain_pivot

	self.add_child(subset)

	return subset

func _update_aabb():
	self.aabb = AABB(
		Vector3(chunk_position.x - aabb_margin, -_visibility_height_range / 2, chunk_position.y - aabb_margin),
		Vector3(chunk_size.x + 2 * aabb_margin, _visibility_height_range, chunk_size.y + 2 * aabb_margin)
	)

func generate():
	_update_aabb()
	connect("camera_entered", self, "_camera_entered")
	connect("camera_exited", self, "_camera_exited")
	var biome: Object = null
	biome_resource.clear_cache()
	var biome_data: Array = biome_resource.get_biome_subsets()
	var dithering_scale = biome_resource.get_min_footprint()
	for x in biome_data:
		if x.enabled == false:
			continue;
		biome = create_subset_renderer(x, dithering_scale, x.cast_shadow && not enable_shadow_proxy)
		biome.sampling_array = biome_resource.biome_stamp.get(x.id, [])
		biome.generate()
		_biomes_subsets.append(biome)
		if x.cast_shadow && enable_shadow_proxy: #add shadow proxy
			var biome_shadow = create_subset_renderer(x, dithering_scale, true)
			biome_shadow.sampling_array = biome.sampling_array
			biome_shadow.generate()
			_biomes_subsets.append(biome_shadow)

func update_chunk():

	_update_aabb()
	for x in _biomes_subsets:
		x.chunk_position = chunk_position
		x.generate()

func update_subsets_visibility(visibility: bool):
	for x in _biomes_subsets:
		x.update_visibility(visibility)

func _camera_entered(_camera: Camera):
	self.visible = enabled
	#update_subsets_visibility(enabled)


func _camera_exited(_camera: Camera):
	self.visible = false
	#update_subsets_visibility(false)