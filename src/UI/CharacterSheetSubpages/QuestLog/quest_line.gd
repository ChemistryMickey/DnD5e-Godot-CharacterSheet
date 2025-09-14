extends Control
class_name QuestLine

enum Status {InProgress, Complete, Failed}

@export var is_selected: bool = false
@export var status: Status = Status.InProgress

func save():
	var save_dict = {}
	save_dict["Title"] = $Container/VBoxContainer/Title.text
	save_dict["Giver"] = $Container/VBoxContainer/Giver.text
	save_dict["InGameDate"] = $Container/VBoxContainer/InGameDate.text
	save_dict["IRLDate"] = $Container/VBoxContainer/IRLDate.text
	
	save_dict["KeyPlayers"] = $Container/KeyPlayers.text
	save_dict["Description"] = $Container/Description.text
	save_dict["Events"] = $Container/Events.text
	
	save_dict["Status"] = self.status
	
	return save_dict
	
func load_sheet(save_dict):
	$Container/VBoxContainer/Title.text = save_dict["Title"]
	$Container/VBoxContainer/Giver.text = save_dict["Giver"]
	$Container/VBoxContainer/InGameDate.text = save_dict["InGameDate"]
	$Container/VBoxContainer/IRLDate.text = save_dict["IRLDate"]
	
	$Container/KeyPlayers.text = save_dict["KeyPlayers"]
	$Container/Description.text = save_dict["Description"]
	$Container/Events.text = save_dict["Events"]
	
	self.status = save_dict["Status"]

func set_irl_date(s: String) -> void:
	$Container/VBoxContainer/IRLDate.text = s

func was_moved(color_toggle: bool = false) -> void:
	self.is_selected = color_toggle
	$Container/Select.button_pressed = color_toggle
	if color_toggle:
		$SelectHighlight.color.a = 0.3
	else:
		$SelectHighlight.color.a = 0

func _on_select_toggled(toggled_on: bool) -> void:
	self.was_moved(toggled_on)
