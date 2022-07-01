extends Node

# Maps unique IDs of actions to Action instances.
var ACTIONS := {}

func _ready() -> void:
	var actions := _load_actions()
	for action in actions:
		ACTIONS[action.id] = action


func get_action_by_id(id: String) -> Action:
	if not id in ACTIONS:
		push_error("Trying to get nonexistent action %s in actions database" % id)
		return null

	return ACTIONS[id]

func get_action_by_rank(rank: int) -> Action:
	return null

static func _load_actions() -> Array:
	var action_resources = []
	var files = _get_dir_contents("res://resources/actions")
	for f in files:
		action_resources.append(load(f))

	# Ensure each loaded action has valid data in debug builds.
	if OS.is_debug_build():
		var ids := []
		var bad_actions := []
		for action in action_resources:
			if action.id in ids:
				bad_actions.append(action)
			else:
				ids.append(action.id)
		for action in bad_actions:
			push_error("Item %s has a non-unique ID: %s" % [action.title, action.id])

	return action_resources


static func _get_dir_contents(rootPath: String) -> Array:
	 var files = []
	 var directories = []
	 var dir = Directory.new()

	 if dir.open(rootPath) == OK:
		  dir.list_dir_begin(true, false)
		  _add_dir_contents(dir, files, directories)
	 else:
		  push_error("An error occurred when trying to access the path.")

	 return files

static func _add_dir_contents(dir: Directory, files: Array, directories: Array):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		if dir.current_is_dir():
			var sub_dir = Directory.new()
			sub_dir.open(path)
			sub_dir.list_dir_begin(true, false)
			directories.append(path)
			_add_dir_contents(sub_dir, files, directories)
		else:
			files.append(path)
		file_name = dir.get_next()
	dir.list_dir_end()
