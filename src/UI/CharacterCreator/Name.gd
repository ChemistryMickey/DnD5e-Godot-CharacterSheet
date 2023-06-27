extends LineEdit

func save():
	var save_dict = {
		"Name" : self.text
	}
	return save_dict
