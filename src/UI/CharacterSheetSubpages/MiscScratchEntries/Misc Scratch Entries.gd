extends HBoxContainer

func save():
	var save_dict = {
		"Misc Scratch Entries" : $TextEdit.text
	}
	return save_dict
	
func load_sheet(save_dict):
	$TextEdit.text = save_dict["Misc Scratch Entries"]
