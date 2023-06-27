extends TextEdit

func save():
	var save_dict = {
		"Motivation" : self.text
	}
	return save_dict
