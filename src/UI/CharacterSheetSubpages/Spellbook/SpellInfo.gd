extends VBoxContainer

func _ready() -> void:
	if Signals.connect("spell_info_requested", Callable(self, "update_spell_info")):
		print("Unable to connect to spell_info_requested")
	
func update_spell_info(spell : String):
	if spell.count('---') > 0:
		return
	var chosen_spell = DatabaseLoader.json_dicts["spell-descriptions"][spell]
	$SpellType/LineEdit.text = chosen_spell["School"]
	$Action/LineEdit.text = chosen_spell["Casting Time"]
	$Range/LineEdit.text = chosen_spell["Range"]
	$Components/LineEdit.text = chosen_spell["Components"]
	$Duration/LineEdit.text = chosen_spell["Duration"]
	$SpellName/LineEdit.text = spell
	$Effect/TextEdit.text = chosen_spell["Description"]
	
