extends ItemList

const spell_levels = ["Cantrips", "1st Level", "2nd Level", "3rd Level", 
					"4th Level", "5th Level", "6th Level", "7th Level",
					"8th Level", "9th Level"]
const json_search_strs = ["cantrip", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

func _ready() -> void:
	if Signals.connect("add_to_prepared_spells", Callable(self, "insert_new_spell")):
		print("Unable to connect to add_to_prepared_spells")
	add_spell_level_delimiters()

func save():
	var save_dict = {"Prepared Spells" : []}
	for idx in range(self.get_item_count()):
		var spell_str = self.get_item_text(idx)
		if not spell_str.count('--') > 0:
			save_dict["Prepared Spells"].append(spell_str)
	return save_dict
	
func load_sheet(save_dict):
	self.clear()
	add_spell_level_delimiters()
	
	for spell in save_dict["Prepared Spells"]:
		insert_new_spell(spell)
		
	Signals.emit_signal("prepared_spells_changed", get_current_prepared_dict())

func add_spell_level_delimiters():
	for level in spell_levels:
		self.add_item("---------- %s" % level, null, false)
		
func insert_new_spell(spell_to_add):
	var current_spell_dict = get_current_prepared_dict()
	spell_to_add = spell_to_add.strip_edges()
	var new_spell_entry = DatabaseLoader.json_dicts["spell-descriptions"][spell_to_add]
	var spell_type_text : String = new_spell_entry["Level"]
	for i in range(spell_levels.size()):
		if spell_type_text.to_lower().count(json_search_strs[i]) > 0:
			if not spell_to_add in current_spell_dict[spell_levels[i]]:
				current_spell_dict[spell_levels[i]].append(spell_to_add)
				current_spell_dict[spell_levels[i]].sort()
			break;
			
	self.clear()
	for key in current_spell_dict.keys():
		self.add_item("---------- %s" % key, null, false)
		for spell in current_spell_dict[key]:
			self.add_item(spell)
	Signals.emit_signal("prepared_spells_changed", current_spell_dict)
	
func get_current_prepared_dict() -> Dictionary:
	var current_prepared_spells = []
	for i in range(self.get_item_count()):
		current_prepared_spells.append( self.get_item_text(i) )
	var spell_dict = {}
	for level in spell_levels:
		spell_dict[level] = []
		
	for spell in current_prepared_spells:
		# Get spell level
		if spell.count('--') < 1:
			var spell_entry = DatabaseLoader.json_dicts["spell-descriptions"][spell]
			var spell_type_text : String = spell_entry["Level"]
			for i in range(spell_levels.size()):
				if spell_type_text.count(json_search_strs[i]) > 0:
					if not spell in spell_dict[spell_levels[i]]:
						spell_dict[spell_levels[i]].append(spell)
						spell_dict[spell_levels[i]].sort()
	return spell_dict
