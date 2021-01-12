class_name FileUtils

static func get_files_from_path(path : String, extensions : Array = []) -> Dictionary:
	var files = {}
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	while file != '':
		if extensions.has(file.get_extension()):
			files[file.get_basename()] = path + file
		file = dir.get_next()
	return files

static func load_files_from_path(path : String, extensions : Array = []) -> Dictionary:
	var result = {}
	var files = get_files_from_path(path,extensions)
	for key in files:
		result[key] = load(files[key])
	return result
