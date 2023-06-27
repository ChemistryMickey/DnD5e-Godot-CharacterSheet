extends VBoxContainer

func _ready() -> void:
	if Signals.connect("spell_info_requested", self, "update_spell_info"):
		print("Unable to connect to spell_info_requested")
	
func update_spell_info(spell : String):
	if spell.count('---') > 0:
		return
	var chosen_spell = DatabaseLoader.json_dicts["spellcasting"]["Spell Descriptions"][spell]["content"]
	$SpellType/LineEdit.text = chosen_spell[0].replace('*', '').strip_edges()
	$Action/LineEdit.text = chosen_spell[1].split('**Casting Time:** ')[1]
	$Range/LineEdit.text = chosen_spell[2].split("**Range:** ")[1]
	$Components/LineEdit.text = chosen_spell[3].split("**Components:** ")[1]
	$Duration/LineEdit.text = chosen_spell[4].split("**Duration:** ")[1]
	$SpellName/LineEdit.text = spell
	
	# Process the rest of the content as newlined stuff
	var description_str = ""
	var additional_list = ""
	for line in range(5, chosen_spell.size()):
		if chosen_spell[line] is Array:
			for additional_line in chosen_spell[line]:
				additional_list += additional_line
				additional_list += "\n"
			description_str += additional_list
		else:
			description_str += chosen_spell[line]
			description_str += "\n"
		
	$Effect/TextEdit.text = description_str
