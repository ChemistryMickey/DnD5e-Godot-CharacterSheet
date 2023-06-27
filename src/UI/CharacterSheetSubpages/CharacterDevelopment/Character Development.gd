extends HBoxContainer

func save():
	var save_dict = {
		"Backstory" : $Left/Backstory.text,
		"Personality" : $Left/Personality.text,
		"Motivation" : $Left/Motivation.text,
		"Friends and Contacts" : $Right/Contacts.text
	}
	return save_dict
	
func load_sheet(save_dict):
	$Left/Backstory.text = save_dict["Backstory"]
	$Left/Personality.text = save_dict["Personality"]
	$Left/Motivation.text = save_dict["Motivation"]
	if save_dict.has("Friends and Contacts"):
		$Right/Contacts.text = save_dict["Friends and Contacts"]

