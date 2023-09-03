extends Node

# Autoloaded things are preserved between scenes
var json_dicts : Dictionary = {}
var cheatsheets : Dictionary = {}

func _ready() -> void:
	load_databases()
	load_cheatsheets()
	
func load_cheatsheets():
	Utilities.load_jsons_from_dir("res://cheatsheets/base", cheatsheets)
	
	var custom_cheatsheets = {}
	Utilities.load_jsons_from_dir("res://cheatsheets/custom", custom_cheatsheets)
	
	cheatsheets = Utilities.recursive_dict_merge(cheatsheets, custom_cheatsheets)
		
func load_databases() -> void:
	Utilities.load_jsons_from_dir("res://databases/base", json_dicts)

	var custom_jsons = {}
	Utilities.load_jsons_from_dir("res://databases/custom", custom_jsons)
	
	json_dicts = Utilities.recursive_dict_merge(json_dicts, custom_jsons)		
		
func parse_table(table_dict : Dictionary, depth : int = 0) -> String:
	var out_str = ""
	const tab_str = "\t\t\t\t"
	
	if table_dict.is_empty():
		return ""
	
	# Print header
	for col in table_dict:
		for _i in range(depth):
			out_str += "\t"
		out_str += col + tab_str
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
			out_str += str(table_dict[col][row]) + tab_str
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
			
	# Enforce a maximum line length:
	const MAX_STR_LEN = 150
	var every_line  = str_out.split("\n")
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
		str_out += "\n" #Add a new line before going to the next line in every_line
	
	return str_out

func calc_col_width(col_name: String, column: Array) -> int:
	var max_len: int = 0
	for item in column:
		if len(item) > max_len:
			max_len = len(item) + 1 # for the final space
	if len(col_name) > max_len:
		max_len = len(col_name)
	
	return max_len
	
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
			out_str += "\t\tAbility Score Increases:\n%s\n" % parse_table(race["Subraces"][subrace]["Ability Score Increases"], 3)
			out_str += "\t\tAbilities: \n"
			out_str += parse_list(race["Subraces"][subrace]["Abilities"], 3)
	return out_str
