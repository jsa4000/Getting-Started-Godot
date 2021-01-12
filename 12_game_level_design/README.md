# Game Level Design

## Godot Addons

Addons needed to enable into Godot engine.

The addons can be installed via Godot IDE and using the `AssetLib` Tab. There is another method that is download it directly from the repository (Github) and copy them into the `addons` folder.

In order to enable the addon: Project Settings -> Plugins -> Add desired plugins

- [Heightmap terrain (Zylann)](https://github.com/Zylann/godot_heightmap_plugin)
- [Godot Scatter Plugin (Zylann)](https://github.com/Zylann/godot_scatter_plugin)
- [Godot Channel Packer Plugin](https://github.com/Zylann/godot_channel_packer_plugin)
- [Godot Volumetrics Plugin](https://github.com/SIsilicon/Godot-Volumetrics-Plugin)
- [Godot Planar Reflection Plugin)](https://github.com/SIsilicon/Godot-Planar-Reflection-Plugin)
- [Godot God Rays Plugin](https://github.com/SIsilicon/Godot-God-Rays-Plugin)
- [Godot Lens Flare Plugin](https://github.com/SIsilicon/Godot-Lens-Flare-Plugin)
- [DecalCo (Decals Plugin)](https://github.com/Master-J/DecalCo)
  > This is **NOT** an addon perse, it is just a new node with a shader.
- [VPainter (Vertex Painter)](https://github.com/tomankirilov/VPainter)
- [Godot Utils and Others](https://github.com/danilw/godot-utils-and-other)
  > This is **NOT** an addon perse, it is just a new node with a shader.
- [Godot Sky Shader](https://github.com/Lexpartizan/Godot_sky_shader)
- [Godot Realistic Water](https://github.com/godot-extended-libraries/godot-realistic-water)
- [Godot Biomes](https://github.com/wojtekpil/Godot-Biomes)
- [Godot First Person Starter](https://github.com/Whimfoome/godot-FirstPersonStarter)
  > Remap the input keys into the project (Ctrl + F8 in MacOS to quit the application)

## Tools

### Blender

- [BlenderGIS](https://github.com/domlysz/BlenderGIS)

  1. Download repository from Github
  2. Install Add-on in blender, enable it, and select a cache folder into settings.
  3. Search for a location using Google Earth or any known locations to be created
  4. In object mode, select GIS -> Web Geodata -> BaseMap. In this window select the `Google` and `Satellite` options and press OK.
  5. Press "G" button and select a location `Kiso` and a scale (15), and press OK.
  6. Press mouse button (middle?) and "E" so the current map will be placed into a 3D plane.
  7. To get the elevation Get select GIS -> Web Geodata -> GetSRTM.
  8. Modify the heights and the modifiers to get the desired shape for the terrain. (Wait)
  9. Open new viewport and choose "Image Editor" and select from the menu, both the **Rastered** and **SRTM** images. Save them into a local drive. Image -> Save As
  10. Convert tiff files into jpeg in order to reduce the size of the images. Then apply the new images into the materials in blender or use them in godot directly, heightmap and raster images. Heightmap must be resized and modified the exposure to be used by Godot and Heightmap.
  11. [Optional] Open them in Photoshop and select Resize Image. Use the `Preserve Details 2.0` resample algorithm to reescale the image.

### Terrain Party

Terrain Party is a website that provides map information. https://terrain.party/

1. From the web it can be selected an area to download the altitude information.
2. From the downloaded file select the merged file and import into Photoshop. Save the image as a raw file.
3. Create an HTerrain node and generate the terrain using the raw file and using `Big Endian+` format (300  max-height).

### Photoshop (Pack)

In order to pack png images with alhpa, needed to be used for terrain editor for bump and roughness materials, it is needed **SuperPNG** plugin for Photoshop installed.
Channel alpha must the added and used before saved. Finally, save the image selecting SuperPNG format and enabling the last transparency options.

## Modifications

## Terrain editor

```python
export(ShaderMaterial) var custom_material : ShaderMaterial setget set_custom_material, get_custom_material

func set_custom_material(material):
	if custom_material == material:
		return
	custom_material = material
	_material = custom_material
	if is_inside_tree():
		_update_material()

func get_custom_material():
	return custom_material

func _init():
	if custom_material != null:
		_material = custom_material
	else:
		_default_shader = load(DEFAULT_SHADER_PATH)
		_material = ShaderMaterial.new()
		_material.shader = _default_shader

```

```python

static func _get_random_instance_basis(scale_randomness: float) -> Basis:
	var sr = rand_range(0, scale_randomness)
	var s = 1.0 + (sr * sr * sr * sr * sr) * 50.0

	var basis = Basis()
	basis = basis.scaled(Vector3(1, s, 1))
	basis = basis.rotated(Vector3(1, 0, 0), -90) # Added initial inclination
	basis = basis.rotated(Vector3(0, 1, 0), rand_range(0, PI))

	return basis

```

```c
render_mode cull_disabled;
//rnder_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
//render_mode blend_mix,depth_draw_alpha_prepass,cull_disabled,diffuse_burley,specular_schlick_ggx;


void fragment() {
	NORMAL = (INV_CAMERA_MATRIX * (WORLD_MATRIX * vec4(v_normal, 0.0))).xyz;
	//ALPHA_SCISSOR = 0.5;
}
```

## DecalsCo and Motion Blur

```python
func _init() -> void :
	#Instantiate the decal's projector mesh and it's decal material
	mesh = CubeMesh.new();
	cast_shadow = false;
	
	decal_material = ShaderMaterial.new();
	decal_material.shader = DECAL_SHADER;

	set("material/0", decal_material);
	# COMMENTED - DECALS ARE NOT SHOWN IF MOTION BLUR
	#decal_material.render_priority = -1;	#Needed in order to make the decal render behind transparent geometry
```