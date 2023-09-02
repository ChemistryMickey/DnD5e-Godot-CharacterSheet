extends VBoxContainer

var line_item = preload("res://src/UI/CharacterSheetSubpages/Cheatsheets/LabelTextPair.tscn")

func _ready() -> void:
	Signals.connect("cheatsheet_info_requested", Callable(self, "update_info"))
	
func update_info(cheatsheet, subsheet):
	for child in self.get_children():
		child.queue_free()
		
	if cheatsheet == "Races":
		var textedit = TextEdit.new()
		textedit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
		textedit.size_flags_horizontal = textedit.SIZE_EXPAND_FILL
		textedit.size_flags_vertical = textedit.SIZE_EXPAND_FILL
		textedit.text = DatabaseLoader.stringify_race(DatabaseLoader.json_dicts["races"][subsheet])
		self.add_child(textedit)
		return
		
	var cur_dict : Dictionary
	if subsheet != "":
		cur_dict = DatabaseLoader.cheatsheets[cheatsheet][subsheet]
	else:
		cur_dict = DatabaseLoader.cheatsheets[cheatsheet]
	
	for item in cur_dict:
		var content_str = parse_content(cur_dict[item])
		var new_line = line_item.instantiate()
		new_line.set_props(item, content_str)
		self.add_child(new_line)
		
func parse_content(content) -> String:
	var ret_str : String = ""
	if content is String:
		ret_str = content
	if content is Array:
		for item in content:
			if item is String:
				ret_str += "%s\n" % item
			if item is Array:
				for subitem in item:
					ret_str += "%s\n" % subitem
			if item is Dictionary:
				pass
	if content is Dictionary:
		for entry in content:
			if entry == "table":
				ret_str += DatabaseLoader.parse_table(content[entry])
			else:
				ret_str += "%s\n\t%s\n" % [entry, content[entry]]
		
	return ret_str

	
