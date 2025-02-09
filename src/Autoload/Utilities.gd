extends Node
@export var num_inventory_entries: int = 0
func find_in_dictionary(dict: Dictionary, term):
	if dict is Dictionary:
		if not dict.has(term):
			for item in dict:
				var output = find_in_dictionary(dict[item], term)
				if output is Dictionary:
					if not output.is_empty():
						return output

		else:
			return dict[term]
	else:
		return {}

func load_json_from_dir(path: String, dict: Dictionary, json: String) -> void:
	var contents = FileAccess.open("%s/%s" % [path, json], FileAccess.READ).get_as_text()
	dict[json.split('.')[0]] = JSON.parse_string(contents)

func load_jsons_from_dir(path: String, dict: Dictionary) -> void:
	var dir: PackedStringArray = DirAccess.open(path).get_files()
	if dir.is_empty():
		return
		
	for cur_file in dir:
		load_json_from_dir(path, dict, cur_file)

func output_json(path: String, dict: Dictionary) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(dict, "\t"))
	#NOTE: FileAccess objects close when they go out of scope so it doesn't need to be closed

func recursive_clear_lineedits(children: Array[Node]) -> void:
	# DEPRICATED. Use recursive_clear_text instead
	for child in children:
		if child.get_child_count() != 0:
			recursive_clear_lineedits(child.get_children())
		
		if child is LineEdit:
			child.text = ""

func recursive_clear_textedits(children: Array[Node]) -> void:
	# DEPRICATED. Use recursive_clear_text instead
	for child in children:
		if child.get_child_count() != 0:
			recursive_clear_textedits(child.get_children())
		
		if child is TextEdit:
			child.text = ""

func recursive_clear_text(children: Array[Node]) -> void:
	for child in children:
		if child.get_child_count() != 0:
			recursive_clear_text(child.get_children())
		
		if child is TextEdit or child is LineEdit:
			child.text = ""

func recursive_clear_spinbox(children: Array[Node]) -> void:
	for child in children:
		if child.get_child_count() != 0:
			recursive_clear_spinbox(child.get_children())
		
		if child is SpinBox:
			child.set_value_no_signal(0)
			child.max_value = 100
			child.prefix = ""
			child.suffix = ""

func recursive_dict_merge(dict1: Dictionary, dict2: Dictionary) -> Dictionary:
	var merged_dict = {}
	for key in dict1.keys():
		# Make simple copy of dict1
		merged_dict.merge({key: dict1[key]}) 
		
	for key in dict2.keys():
		if dict2[key] is Dictionary and merged_dict.has(key):
			merged_dict[key].merge(recursive_dict_merge(merged_dict[key], dict2[key]))
		elif dict2[key] is Array and merged_dict.has(key):
			for item in dict2[key]:
				if item not in merged_dict[key]:
					merged_dict[key].append(item)
		else:
			merged_dict[key] = dict2[key]
	return merged_dict

func recursive_construct_savable_child_dict(children: Array[Node], mutable_dict: Dictionary, parent_name: String, cur_depth: int = 0) -> void:
	for child in children:
		var full_name
		if cur_depth == 0:
			full_name = child.name
		else:
			full_name = "%s/%s" % [parent_name, child.name]
			
		if child.get_child_count() > 0:
			recursive_construct_savable_child_dict(child.get_children(), mutable_dict, full_name, cur_depth + 1)
		
		if child is LineEdit:
			mutable_dict[full_name] = child.text
			#print("I'm a line edit! %s" % full_name)
		elif child is TextEdit:
			mutable_dict[full_name] = child.text
			#print("I'm a text edit! %s" % full_name)
		elif child is SpinBox:
			mutable_dict[full_name] = {"value": child.value, "max value": child.max_value}
			#print("I's a spin box! %s" % full_name)
		elif child is CheckButton:
			mutable_dict[full_name] = child.toggle_mode
			#print("I'm a check button! %s" % full_name)
	return

func replace_every_nth_chr(str_in: String, char_to_replace: String, replace_with: String, n: int) -> String:
	var new_str = str_in
	var counter = 0
	var i = 0
	for chr in new_str:
		if chr == char_to_replace:
			counter += 1
		if counter == n:
			new_str[i] = replace_with
			counter = 0
		i += 1
	return new_str

func strip_bbcode_tags(str_in: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(str_in, "", true)

func unique(arr_in : Array) -> Array:
	# Doesn't sort
	var array_out = []
	for item in arr_in:
		if item in array_out:
			continue
		array_out.append(item)
	return array_out

func XOR(b1: bool, b2: bool) -> bool:
	return b1 != b2;
