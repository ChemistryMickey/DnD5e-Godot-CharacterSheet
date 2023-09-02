extends Node

# Autoloaded things are preserved between scenes
var json_dicts : Dictionary = {}
var cheatsheets : Dictionary = {}

func _ready() -> void:
	load_jsons()
	load_cheatsheets()
	
func load_cheatsheets():
	var json_raw_strs = []
	var filenames = []
	var dir = DirAccess.open("res://cheatsheets/")
	if dir:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var cur_file = dir.get_next()

		while cur_file != "":
			var file = FileAccess.open("res://cheatsheets/%s" % cur_file, FileAccess.READ)
			var contents = file.get_as_text()
			file.close()
			json_raw_strs.append(contents)
			
			filenames.append(cur_file.split('.')[0])
			cur_file = dir.get_next()
		
	for idx in range(filenames.size()):
		var test_json_conv = JSON.parse_string(json_raw_strs[idx])
		cheatsheets[filenames[idx]] = test_json_conv
	
func load_jsons():
	var json_raw_strs = []
	var filenames = []
	var dir = DirAccess.open("res://databases/")
	if dir:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var cur_file = dir.get_next()

		while cur_file != "":
			var file = FileAccess.open("res://databases/%s" % cur_file, FileAccess.READ)
			var contents = file.get_as_text()
			file.close()
			json_raw_strs.append(contents)
			
			filenames.append(cur_file.split('.')[0])
			cur_file = dir.get_next()
		
	for idx in range(filenames.size()):
		var test_json_conv = JSON.parse_string(json_raw_strs[idx])
		json_dicts[filenames[idx]] = test_json_conv
		
func parse_table(table_dict : Dictionary, depth : int = 0) -> String:
	var tab_str = determine_num_tabs(table_dict)
	var out_str = ""
	if not table_dict.is_empty():
		for col in table_dict:
			for _i in range(depth):
				out_str += "\t"
			out_str += "%s%s" % [col, tab_str]
		out_str += "\n"
		for _i in range(depth):
				out_str += "\t"
		for cha in out_str.length():
			out_str += '-'
		out_str += "\n"
		for row in range(table_dict[table_dict.keys()[0]].size()):
			for col in table_dict:
				for _i in range(depth):
					out_str += "\t"
				out_str += "%s%s" % [table_dict[col][row], tab_str]
			out_str += "\n"
	
	return out_str

func parse_list(list_in : Array, depth : int = 0) -> String:
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

	return str_out

func determine_num_tabs(_table_dict : Dictionary) -> String:
	#TODO make this smarter
	
	return "\t\t\t\t\t\t\t"
	
func stringify_race(race : Dictionary) -> String:
	var out_str = ""
	out_str += "%s\n\n" % race["Description"]
	out_str += "Ability Score Increases:\n%s\n" % parse_table(race["Ability Score Increases"], 1)
	out_str += "Age:\n\t%s\n" % race["Age"]
	out_str += "Size:\n\t%s\n" % race["Size"]
	out_str += "Move Speeds: \n"
	out_str += "\tWalking: %s\n\tClimbing: %s\n\tSwimming: %s\n\tFlying: %s\n" % \
		[race["Speeds"]["Walking"], race["Speeds"]["Climbing"], 
		race["Speeds"]["Swimming"] ,race["Speeds"]["Flying"]]
	out_str += "\nAbilities: \n"
	out_str += parse_list(race["Abilities"], 1)
	if not race["Tool Proficiencies"].is_empty():
		out_str += "\nTool Proficiencies: \n"
		for item in race["Tool Proficiencies"]:
			if item is String:
				out_str += "\t%s\n" % item
			if item is Array:
				out_str += "\t"
				out_str += "\tOR\t".join(item)
	out_str += "\nLanguages: \n"
	for lang in race["Languages"]:
		out_str += "\t%s\n" % lang
		
	if not race["Subraces"].is_empty():
		out_str += "\nSubraces: \n"
		for subrace in race["Subraces"]:
			out_str += "\t%s: \n" % subrace
			out_str += "\tAbility Score Increases:\n%s\n" % parse_table(race["Subraces"][subrace]["Ability Score Increases"], 2)
			out_str += "\tAbilities: \n"
			out_str += parse_list(race["Subraces"][subrace]["Abilities"], 2)
	return out_str
