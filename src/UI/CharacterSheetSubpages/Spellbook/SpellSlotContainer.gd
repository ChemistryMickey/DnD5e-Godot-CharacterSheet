extends GridContainer

func save():
	var save_dict = {
		"Spell Slots": [
			[$"1stLevel/LineEdit".text, $"1stLevel/LineEdit2".text],
			[$"2ndLevel/LineEdit".text, $"2ndLevel/LineEdit2".text],
			[$"3rdLevel/LineEdit".text, $"3rdLevel/LineEdit2".text],
			[$"4thLevel/LineEdit".text, $"4thLevel/LineEdit2".text],
			[$"5thLevel/LineEdit".text, $"5thLevel/LineEdit2".text],
			[$"6thLevel/LineEdit".text, $"6thLevel/LineEdit2".text],
			[$"7thLevel/LineEdit".text, $"7thLevel/LineEdit2".text],
			[$"8thLevel/LineEdit".text, $"8thLevel/LineEdit2".text],
			[$"9thLevel/LineEdit".text, $"9thLevel/LineEdit2".text]
		]
	}
	return save_dict
	
func load_sheet(save_dict):
	var slot_list = save_dict["Spell Slots"]
	$"1stLevel/LineEdit".text = slot_list[0][0]
	$"1stLevel/LineEdit2".text = slot_list[0][1]
	
	$"2ndLevel/LineEdit".text = slot_list[1][0]
	$"2ndLevel/LineEdit2".text = slot_list[1][1]
	
	$"3rdLevel/LineEdit".text = slot_list[2][0]
	$"3rdLevel/LineEdit2".text = slot_list[2][1]
	
	$"4thLevel/LineEdit".text = slot_list[3][0]
	$"4thLevel/LineEdit2".text = slot_list[3][1]
	
	$"5thLevel/LineEdit".text = slot_list[4][0]
	$"5thLevel/LineEdit2".text = slot_list[4][1]
	
	$"6thLevel/LineEdit".text = slot_list[5][0]
	$"6thLevel/LineEdit2".text = slot_list[5][1]
	
	$"7thLevel/LineEdit".text = slot_list[6][0]
	$"7thLevel/LineEdit2".text = slot_list[6][1]
	
	$"8thLevel/LineEdit".text = slot_list[7][0]
	$"8thLevel/LineEdit2".text = slot_list[7][1]
	
	$"9thLevel/LineEdit".text = slot_list[8][0]
	$"9thLevel/LineEdit2".text = slot_list[8][1]
