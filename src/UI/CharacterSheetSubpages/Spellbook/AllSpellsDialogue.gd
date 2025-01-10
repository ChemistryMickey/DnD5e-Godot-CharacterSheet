extends Window

func _ready() -> void:
	var all_spell_dict = DatabaseLoader.json_dicts["spell-descriptions"]
	prepare_alphabet_spell_list(all_spell_dict)
	
	var class_spell_dict = DatabaseLoader.json_dicts["spells-by-class"]
	prepare_by_class_list(class_spell_dict)
	prepare_by_level_list(class_spell_dict)

func _on_All_Spells_item_activated(index: int) -> void:
	var spell_request = $"VBoxContainer/TabContainer/All Spells".get_item_text(index)
	activate_item(spell_request)

func _on_By_Level_item_activated(index: int) -> void:
	var spell_request = $"VBoxContainer/TabContainer/By Level".get_item_text(index)
	activate_item(spell_request)

func _on_By_Class_item_activated(index: int) -> void:
	var spell_request = $"VBoxContainer/TabContainer/By Class".get_item_text(index)
	activate_item(spell_request)
	
func activate_item(spell_request):
	if spell_request.count("==") > 0 or spell_request.count("--") > 0:
		return
	Signals.emit_signal("spell_info_requested", spell_request)

func _on_Button_button_up() -> void:
	var selected_inds = []
	if $"VBoxContainer/TabContainer/All Spells".visible:
		selected_inds = $"VBoxContainer/TabContainer/All Spells".get_selected_items()
	elif $"VBoxContainer/TabContainer/By Level".visible:
		selected_inds = $"VBoxContainer/TabContainer/By Level".get_selected_items()
	elif $"VBoxContainer/TabContainer/By Class".visible:
		selected_inds = $"VBoxContainer/TabContainer/By Class".get_selected_items()
		
	if selected_inds.is_empty():
		return
	var index = selected_inds[0]
	var spell_request = ""
	if $"VBoxContainer/TabContainer/All Spells".visible:
		spell_request = $"VBoxContainer/TabContainer/All Spells".get_item_text(index)
	elif $"VBoxContainer/TabContainer/By Level".visible:
		spell_request = $"VBoxContainer/TabContainer/By Level".get_item_text(index)
	elif $"VBoxContainer/TabContainer/By Class".visible:
		spell_request = $"VBoxContainer/TabContainer/By Class".get_item_text(index)
		
	if spell_request.count("==") > 0 or spell_request.count("--") > 0:
		return
	Debug.debug_print("Overriding to add " + spell_request + " to prepared spells")
	Signals.emit_signal("add_to_prepared_spells", spell_request)

func prepare_alphabet_spell_list(all_spells : Dictionary):
	var all_spell_list = []
	for spell in all_spells.keys():
		all_spell_list.append(spell)
	all_spell_list.sort()
	for spell in all_spell_list:
		$"VBoxContainer/TabContainer/All Spells".add_item(spell)
	
func prepare_by_level_list(all_spells : Dictionary):
	var by_level_dict = {}
	for spell_level in all_spells[all_spells.keys()[0]]:
		by_level_dict[spell_level] = []
	for class_choice in all_spells:
		for spell_level in all_spells[class_choice]:
			for spell in all_spells[class_choice][spell_level]:
				by_level_dict[spell_level].append(spell)
			by_level_dict[spell_level] = Utilities.unique(by_level_dict[spell_level])
			
	for spell_level in by_level_dict:
		$"VBoxContainer/TabContainer/By Level".add_item("---------------------- %s" % spell_level, null, false)
		for spell in by_level_dict[spell_level]:
			$"VBoxContainer/TabContainer/By Level".add_item(spell)

func prepare_by_class_list(all_spells : Dictionary):
	for class_choice in all_spells:
		$"VBoxContainer/TabContainer/By Class".add_item("================================== %s" % class_choice, null, false)
		for spell_level in all_spells[class_choice]:
			$"VBoxContainer/TabContainer/By Class".add_item("---------------------- %s" % spell_level, null, false)
			for spell in all_spells[class_choice][spell_level]:
				$"VBoxContainer/TabContainer/By Class".add_item(spell)

func _on_close_requested():
	self.hide() # Replace with function body.
