# README

## Mixamo

- Select the character and export to `fbx` format using `T-Pose`.
- Select desired animations depending on the *states* and *motions*: walk, run, jump, push, idle, etc..
- Enable or disable `In Place`if **root motion** is going to be used.
- Export animations into `fbx` formaat **without skin**. Select the desired FPS depending on the quality and detail

## Blender

- Import all fbx models into blender.
- For each animation, go to `Dope Sheet` -> `Action Editor` -> Change the name of the animation. For loop animations add `-loop` at the end.
- Delete all `Armatures` except the main character in T-Pose.
- For each renamed animation select the armature (main character) and into the `Dope Sheet` -> `Action Editor` -> `Stash`
- Export the entire armature into glTF format.

## Godot

- Select the glTf object exported from Blender and select `New Inherited`
- [Optional] For each animation save it into a resource so it can be shared into characters with the same armature.
- Add animationTree and start blending and adding animations.