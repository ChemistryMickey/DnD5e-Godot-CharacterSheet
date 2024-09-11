extends OptionButton

func save():
	var save_dict = {
		"Spellcasting Ability" : self.selected
	}
	return save_dict
	
func load_sheet(save_dict : Dictionary):
	if save_dict.has("Spellcasting Ability"):
		self.selected = save_dict["Spellcasting Ability"]
	Signals.emit_signal("request_ability_bonus", self.get_item_text(self.selected))
