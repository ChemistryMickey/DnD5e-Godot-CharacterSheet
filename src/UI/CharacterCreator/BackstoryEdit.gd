extends TextEdit

func save():
	var save_dict = {
		"Backstory" : self.text
	}
	return save_dict
