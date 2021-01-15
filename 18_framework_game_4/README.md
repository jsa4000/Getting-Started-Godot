# READAME

- Build the repository to generate aan executable file

https://docs.godotengine.org/en/stable/development/compiling/compiling_for_osx.html

```bash
# Execute the following command depending on the OS and Architecture
scons platform=osx arch=x86_64 --jobs=$(sysctl -n hw.logicalcpu)
```

- Prepare the App to be opened by OSX

```bash
cp -r misc/dist/osx_tools.app ./Godot.app
mkdir -p Godot.app/Contents/MacOS
cp bin/godot.osx.tools.x86_64 Godot.app/Contents/MacOS/Godot
chmod +x Godot.app/Contents/MacOS/Godot
```

- Copy Vulkan libraries

https://vulkan.lunarg.com/sdk/home#mac

```bash
mkdir -p Godot.app/Contents/Frameworks
cp ../libMoltenVK.dylib Godot.app/Contents/Frameworks/libMoltenVK.dylib
```

```json
{
    "file_format_version" : "1.0.0",
    "ICD": {
       // or "../../../lib/libMoltenVK.dylib",
        "library_path": "/usr/local/lib/libMoltenVK.dylib",
        "api_version" : "1.0.0"
    }
}
```

- Open the App

```bash
open ./Godot.app
```