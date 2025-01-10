extends Node

const BASE_DIR: String = "res://databases/base"
const CUSTOM_DIR: String = "res://databases/custom"

# Autoloaded things are preserved between scenes
var json_dicts: Dictionary = {}
var base_jsons: Dictionary = {}
var custom_jsons: Dictionary = {}


func _ready() -> void:
	load_databases()

func add_pc(pc: Dictionary) -> void:
	custom_jsons["PCs"][pc["Name"]] = pc
	output_custom_jsons("PCs")
	load_databases()

func remove_pc(pc_name: String) -> void:
	if pc_name not in custom_jsons["PCs"].keys():
		return
	custom_jsons["PCs"].erase(pc_name)
	output_custom_jsons("PCs")
	load_databases()

func add_npc(npc: Dictionary) -> void:
	custom_jsons["NPCs"][npc["Name"]] = npc
	output_custom_jsons("NPCs")
	load_databases()

func remove_npc(npc_name: String) -> void:
	if npc_name not in custom_jsons["NPCs"].keys():
		return
	custom_jsons["NPCs"].erase(npc_name)
	output_custom_jsons("NPCs")
	load_databases()

func load_databases() -> void:
	Utilities.load_jsons_from_dir(BASE_DIR, json_dicts)

	if not DirAccess.dir_exists_absolute(CUSTOM_DIR):
		_make_default_custom_dicts()
	var custom = {}
	Utilities.load_jsons_from_dir(CUSTOM_DIR, custom)

	# This order is important so a custom spell/condition will override a base one.
	json_dicts = Utilities.recursive_dict_merge(custom, json_dicts)

	# base_jsons and custom_jsons are specifically used for checking
	#	if something's in the base or custom for adding and deleting
	Utilities.load_jsons_from_dir(BASE_DIR, base_jsons)
	Utilities.load_jsons_from_dir(CUSTOM_DIR, custom_jsons)

func output_custom_jsons(json: String = "") -> void:
	var custom_json_dir = "%s/%s.json"
	if json == "":
		for custom_json in custom_jsons.keys():
			Utilities.output_json(custom_json_dir % [CUSTOM_DIR, custom_json], custom_jsons[custom_json])
	else:
		Utilities.output_json(custom_json_dir % [CUSTOM_DIR, json], custom_jsons[json])


func parse_table(table_dict: Dictionary, depth: int = 0) -> String:
	var out_str = ""
	const TAB_STR = "\t\t\t\t"

	if table_dict.is_empty():
		return ""

	# Print header
	for col in table_dict:
		for _i in range(depth):
			out_str += "\t"
		out_str += col + TAB_STR
	out_str += "\n"

	# Print separator
	for _i in range(len(out_str)):
		out_str += "-"
	out_str += "\n";

	# Print table contents
	for row in range(table_dict[table_dict.keys()[0]].size()):
		for col in table_dict:
			for _i in range(depth):
				out_str += "\t"
			out_str += str(table_dict[col][row]) + TAB_STR
		out_str += "\n"
			
	return out_str

func parse_list(list_in: Array, depth: int = 0) -> String:
	var str_out = ""
	for item in list_in:
		if item is String:
			for _idx in range(depth):
				str_out += "\t"
			str_out += "%s\n" % item
		if item is Dictionary:
			str_out += parse_table(item)
		if item is Array:
			str_out += parse_list(item, depth + 1)
			
	# Enforce a maximum line length:
	const MAX_STR_LEN = 150
	var every_line = str_out.split("\n")
	str_out = ""
	for line in every_line:
		var every_word = line.split(" ")
		var lines = []
		var cur_line = ""
		for word in every_word:
			cur_line += word + " "
			if len(cur_line) > MAX_STR_LEN:
				lines.append(cur_line)
				cur_line = ""
		lines.append(cur_line)
		str_out += "\n".join(lines)
		str_out += "\n" # Add a new line before going to the next line in every_line
	
	return str_out

func calc_col_width(col_name: String, column: Array) -> int:
	var max_len: int = 0
	for item in column:
		if len(item) > max_len:
			max_len = len(item) + 1 # for the final space
	if len(col_name) > max_len:
		max_len = len(col_name)
	
	return max_len
	
func _make_default_custom_dicts() -> void:
	DirAccess.make_dir_recursive_absolute(CUSTOM_DIR)
	const needed_jsons = ["conditions", "spell-descriptions", "spells-by-class"]
	
	for needed_json in needed_jsons:
		var path = "/".join([CUSTOM_DIR, needed_json + ".json"])
		print("Making path %s" % path)
		Utilities.output_json(path, {})
	return
