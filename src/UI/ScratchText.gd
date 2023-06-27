extends TextEdit

func save():
	var save_dict = {
		"Scratch Text" : self.text
	}
	return save_dict
	
func load_sheet(save_dict):
	self.text = save_dict["Scratch Text"]
