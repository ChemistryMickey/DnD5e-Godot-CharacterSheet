extends Control
class_name NPC_entry

@export var selected_for_delete: bool = false
@export var NPC_name: String = ""
@export var where: String = ""
@export var when: String = ""

func update_when(date_in : String) -> void:
	$HBoxContainer/Date.text = date_in
	when = date_in

func save() -> Dictionary:
	return {
		"Where": where,
		"Date": when,
		"Affiliations": $HBoxContainer/Affiliations.text,
		"Notes": $HBoxContainer/Notes.text
	}
	
func load_save(npc_name: String, info: Dictionary) -> void:
	NPC_name = npc_name
	$HBoxContainer/Name.text = npc_name
	
	where = info["Where"]
	$HBoxContainer/Where.text = info["Where"]
		
	when = info["Date"]
	$HBoxContainer/Date.text = info["Date"]
	
	$HBoxContainer/Affiliations.text = info["Affiliations"]
	$HBoxContainer/Notes.text = info["Notes"]

func _on_check_button_toggled(button_pressed):
	if button_pressed:
		selected_for_delete = true
		$SelectedFilter.show()
	else:
		selected_for_delete = false
		$SelectedFilter.hide()


func _on_name_text_changed(new_text):
	NPC_name = new_text

func _on_where_text_changed(new_text):
	where = new_text

func _on_date_text_changed(new_text):
	when = new_text
