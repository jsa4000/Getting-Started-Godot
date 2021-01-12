# Addons

## Hterrain

`brush_editor.gd

Change max size from 50 to 200

```python
if NativeFactory.is_native_available():
   _size_slider.max_value = 200
else:
   _size_slider.max_value = 50 # -> 200
```

## Decalco

Commented line in `Decal.gd` file to fix an issue with `CanvaItem` shaders do not been rendered properly.

```python
func _init() -> void :
   #Instantiate the decal's projector mesh and it's decal material
   mesh = CubeMesh.new();
   cast_shadow = false;

   decal_material = ShaderMaterial.new();
   decal_material.shader = DECAL_SHADER;

   set("material/0", decal_material);
   ##
   ## Commented JSA
   ##
   #decal_material.render_priority = -1;    #Needed in order to make the decal render behind transparent geometry
```

## Camera

Following code must be added into `project.godot` to configure the action mappings.

```json
[input]

ui_accept={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777221,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777222,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":32,"unicode":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":0,"pressure":0.0,"pressed":false,"script":null)
 ]
}
move_forward={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":87,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777232,"unicode":0,"echo":false,"script":null)
 ]
}
move_backward={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":83,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777234,"unicode":0,"echo":false,"script":null)
 ]
}
move_left={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":65,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777231,"unicode":0,"echo":false,"script":null)
 ]
}
move_right={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":68,"unicode":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777233,"unicode":0,"echo":false,"script":null)
 ]
}
move_sprint={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777237,"unicode":0,"echo":false,"script":null)
 ]
}
move_jump={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":false,"control":false,"meta":false,"command":false,"pressed":false,"scancode":32,"unicode":0,"echo":false,"script":null)
 ]
}
mouse_input={
"deadzone": 0.5,
"events": [ Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":0,"alt":false,"shift":true,"control":false,"meta":false,"command":false,"pressed":false,"scancode":16777244,"unicode":0,"echo":false,"script":null)
 ]
}

```

## Improvements (Backlog)

### Framework

- Check Camera collision on top surfaces [HIGH]
- Interpolate player movements when the camera view changes radically using a threshold angle. [LOW]
- Modify CameraTarget so it can bee used also to retrieve AABB from Bodies as a component [MEDIUM]
- Create a specific state in StateMachine so it has priory over the others to transition to (Any) [LOW]
- Create IK to the player so the face turns over the objects that can interact with. [LOW]

## Resources

### Icons

- [Free Icons](https://loading.io/)
- [Online SVG Editor](https://editor.method.ac/)

### 3D Models

- [3D mbd](https://3dmdb.com)
- [SketcFab](https://sketchfab.com)
- [CG Trader](https://www.cgtrader.com)
- [Free 3d Models](https://free3d.com)
- [Turb Squid](https://www.turbosquid.com)

### Panoramos HDR

- [HRI Heaven](https://hdrihaven.com)


