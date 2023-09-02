extends HBoxContainer
class_name JournalEntry

@export var is_empty: bool = true

func save():
	var save_dict = {}
	save_dict["Timestamp"] = $VBoxContainer/IRLEdit.text
	save_dict["In Game Timestamp"] = $VBoxContainer/IGEdit.text
	save_dict["Entry"] = $Entry.text
	
	return save_dict
	
func load_sheet(save_dict):
	$VBoxContainer/IRLEdit.text = save_dict["Timestamp"]
	$VBoxContainer/IGEdit.text = save_dict["In Game Timestamp"]
	$Entry.text = save_dict["Entry"]
