extends VBoxContainer

var exp_log_template = preload("res://src/UI/CharacterSheetSubpages/TransactionLog/ExperienceEntry.tscn")

func save():
	var save_dict = {"Experience Entries" : []}
	for child in self.get_children():
		save_dict["Experience Entries"].append(child.save())
	return save_dict
	
func load_sheet(save_dict):
	for child in self.get_children():
		child.queue_free()
		
	for entry in save_dict["Experience Entries"]:
		var new_entry = exp_log_template.instance()
		new_entry.load_sheet(entry)
		self.add_child(new_entry)
		
	Signals.emit_signal("exp_changed")
