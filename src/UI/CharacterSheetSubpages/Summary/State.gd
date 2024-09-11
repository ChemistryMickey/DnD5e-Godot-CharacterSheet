extends HBoxContainer

func save():
	var save_dict = {
		"HP" : $hpEdit.text,
		"Max HP" : $maxHPEdit.text,
		"Temp HP" : $tempHPEdit.text,
		"Hit Die" : $hitDieEdit.text
	}
	return save_dict
	
func load_sheet(save_dict):
	$hpEdit.text = save_dict["HP"]
	$maxHPEdit.text = save_dict["Max HP"]
	$tempHPEdit.text = save_dict["Temp HP"]
	$hitDieEdit.text = save_dict["Hit Die"]
