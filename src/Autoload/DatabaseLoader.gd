extends Node

# Autoloaded things are preserved between scenes
var json_dicts : Dictionary = {}
var cheatsheets : Dictionary = {}

func _ready() -> void:
	load_databases()
	load_cheatsheets()
	
func load_cheatsheets():
	Utilities.load_jsons_from_dir("res://cheatsheets", cheatsheets)
	
	var custom_cheatsheets = {}
	Utilities.load_jsons_from_dir("res://custom-cheatsheets", custom_cheatsheets)
	
	cheatsheets = Utilities.recursive_dict_merge(cheatsheets, custom_cheatsheets)
		
func load_databases() -> void:
	Utilities.load_jsons_from_dir("res://databases", json_dicts)

	var custom_jsons = {}
	Utilities.load_jsons_from_dir("res://custom-databases", custom_jsons)
	
	json_dicts = Utilities.recursive_dict_merge(json_dicts, custom_jsons)		
		
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
