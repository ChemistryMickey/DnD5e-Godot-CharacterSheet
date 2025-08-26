extends ColorRect
class_name JournalEntry

@export var is_empty: bool = true
@export var is_selected: bool = false

func save():
	var save_dict = {}
	save_dict["Timestamp"] = $HBoxContainer/VBoxContainer/IRLEdit.text
	save_dict["In Game Timestamp"] = $HBoxContainer/VBoxContainer/IGEdit.text
	save_dict["Entry"] = $HBoxContainer/Entry.text
	
	return save_dict
	
func load_sheet(save_dict):
	$HBoxContainer/VBoxContainer/IRLEdit.text = save_dict["Timestamp"]
	$HBoxContainer/VBoxContainer/IGEdit.text = save_dict["In Game Timestamp"]
	$HBoxContainer/Entry.text = save_dict["Entry"]

func set_irl_date(str: String) -> void:
	$HBoxContainer/VBoxContainer/IRLEdit.text = str

func _on_selected_toggled(toggled_on: bool) -> void:
	self.is_selected = toggled_on
	if toggled_on:
		self.color.a = 0.3
	else:
		self.color.a = 0
