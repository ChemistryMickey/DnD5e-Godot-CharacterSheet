extends VBoxContainer

var journal_entry_template = preload("res://src/UI/CharacterSheetSubpages/Journal/JournalEntry.tscn")

func save():
	var save_dict = {"Journal Entries" : []}
	for child in self.get_children():
		if child is JournalEntry:
			save_dict["Journal Entries"].append( child.save() )
	
	return save_dict

func load_sheet(sheet_dict):
	for child in self.get_children():
		child.queue_free() #remove all children
	
	for entry in sheet_dict["Journal Entries"]:
		var new_entry = journal_entry_template.instance()
		new_entry.load_sheet(entry)
		self.add_child(new_entry)
