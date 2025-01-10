extends VBoxContainer

const SPELL_LEVELS = [
	"Cantrips",
	"1st Level",
	"2nd Level",
	"3rd Level",
	"4th Level",
	"5th Level",
	"6th Level",
	"7th Level",
	"8th Level",
	"9th Level"
]
const JSON_SEARCH_STRS = ["cantrip", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

@onready var class_spell_list = $Spells/Left/AllSpells/ItemList
@onready var prepared_spell_list = $Spells/Left/PreparedSpells/PreparedSpellList


func _ready() -> void:
	if Signals.connect("class_updated", Callable(self, "choose_class_spell_list")):
		print("Unable to connect to class_updated!")


func _on_PreparedSpellList_item_activated(index: int) -> void:
	var chosen_spell_str: String = prepared_spell_list.get_item_text(index).strip_edges()
	Debug.debug_print(
		"Updating spellbook information block from prepared list of %s" % chosen_spell_str
	)

	Signals.emit_signal("spell_info_requested", chosen_spell_str)


func _on_AllSpellsButton_button_up() -> void:
	$AllSpellsDialogue.popup_centered(Vector2(-0.5, 0))


func _on_ItemList_item_activated(index: int) -> void:
	var chosen_spell_str: String = class_spell_list.get_item_text(index).strip_edges()
	Debug.debug_print("Updating spellbook information block for %s" % chosen_spell_str)

	Signals.emit_signal("spell_info_requested", chosen_spell_str)


func _on_ClearPreparedSpells_button_up() -> void:
	prepared_spell_list.clear()
	Signals.emit_signal("prepared_spells_changed", get_current_prepared_dict())
	add_spell_level_delimiters()


func _on_RemovePreparedSpell_button_up() -> void:
	# Get selected spell in prepared spell list
	if (
		prepared_spell_list.get_item_count() > 0
		and prepared_spell_list.get_selected_items().size() > 0
	):
		var selected_ind = prepared_spell_list.get_selected_items()
		if not selected_ind.is_empty():
			selected_ind = selected_ind[0]

		# Remove spell from prepared spell list
		prepared_spell_list.remove_item(selected_ind)
		Signals.emit_signal("prepared_spells_changed", get_current_prepared_dict())


func _on_AddToPreparedSpells_button_up() -> void:
	# Insert new spell into appropriate dict spot
	var selected_vals = class_spell_list.get_selected_items()
	if not selected_vals.is_empty():
		var selected_ind = selected_vals[0]
		var spell_to_add = class_spell_list.get_item_text(selected_ind)
		Signals.emit_signal("add_to_prepared_spells", spell_to_add)


func save():
	return {}


func load_sheet(save_dict):
	choose_class_spell_list(save_dict["Class"])


func get_current_prepared_dict() -> Dictionary:
	var current_prepared_spells = []
	for i in range(prepared_spell_list.get_item_count()):
		current_prepared_spells.append(prepared_spell_list.get_item_text(i))
	var spell_dict = {}
	for level in SPELL_LEVELS:
		spell_dict[level] = []

	for spell in current_prepared_spells:
		# Get spell level
		if spell.count("--") < 1:
			var spell_entry = DatabaseLoader.json_dicts["spell-descriptions"][spell]
			var spell_type_text: String = spell_entry["School"]
			for i in range(SPELL_LEVELS.size()):
				if spell_type_text.count(JSON_SEARCH_STRS[i]) > 0:
					if not spell in spell_dict[SPELL_LEVELS[i]]:
						spell_dict[SPELL_LEVELS[i]].append(spell)
						spell_dict[SPELL_LEVELS[i]].sort()
	return spell_dict


func choose_class_spell_list(chosen_class):
	class_spell_list.clear()
	if chosen_class in DatabaseLoader.json_dicts["spells-by-class"]:
		var class_spells = DatabaseLoader.json_dicts["spells-by-class"][chosen_class]

		for key in class_spells.keys():
			class_spell_list.add_item("---------- %s" % key, null, false)
			for spell in class_spells[key]:
				class_spell_list.add_item("\t%s" % spell)


func add_spell_level_delimiters():
	for level in SPELL_LEVELS:
		prepared_spell_list.add_item("---------- %s" % level, null, false)
