extends CheckBox

func save():
	var save_dict = {"Consolidate Money" : self.button_pressed}
	return save_dict
	
func load_sheet(save_dict):
	if "Consolidate Money" in save_dict.keys():
		self.button_pressed = save_dict["Consolidate Money"]
	else: # Backwards Compatibility. This isn't a critical function
		self.button_pressed = true
	Signals.emit_signal("money_changed")
