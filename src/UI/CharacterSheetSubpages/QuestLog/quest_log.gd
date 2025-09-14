extends VBoxContainer
var quest_line = preload("res://src/UI/CharacterSheetSubpages/QuestLog/quest_line.tscn")
@onready var quest_cont_map: Dictionary = {
	QuestLine.Status.InProgress: $Scroll/Quests/InProgress,
	QuestLine.Status.Complete: $Scroll/Quests/Complete,
	QuestLine.Status.Failed: $Scroll/Quests/Failed
}

func save() -> Dictionary:
	var save_dict = {"Quests": []}
	for child in $Scroll/Quests.get_children():
		for subchild in child.get_children():
			if subchild is QuestLine:
				save_dict["Quests"].append(subchild.save())
	return save_dict
	
func load_sheet(save_dict: Dictionary) -> void:
	if "Quests" not in save_dict:
		# Backwards compatibility
		return

	for child in $Scroll/Quests.get_children():
		for subchild in child.get_children():
			if subchild is QuestLine:
				subchild.queue_free()

	for entry in save_dict["Quests"]:
		var new_quest = quest_line.instantiate()
		new_quest.load_sheet(entry)
		
		quest_cont_map[entry["Status"] as QuestLine.Status].add_child(new_quest)

func _on_add_pressed() -> void:
	var new_quest = quest_line.instantiate()
	var cur_date = Time.get_date_string_from_system()
	new_quest.set_irl_date(cur_date)
	$Scroll/Quests/InProgress.add_child(new_quest)

func _on_remove_pressed() -> void:
	for child in $Scroll/Quests.get_children():
		for subchild in child.get_children():
			if subchild is QuestLine and subchild.is_selected:
				subchild.queue_free()

func _on_failed_pressed() -> void:
	self._move_quests($Scroll/Quests/Failed)

func _on_complete_pressed() -> void:
	self._move_quests($Scroll/Quests/Complete)

func _on_in_progress_pressed() -> void:
	self._move_quests($Scroll/Quests/InProgress)

func _move_quests(dest_node: VBoxContainer) -> void:
	for child in $Scroll/Quests.get_children():
		for subchild in child.get_children():
			if subchild is QuestLine and subchild.is_selected:
				child.remove_child(subchild) #NOTE: This doesn't delete the node
				dest_node.add_child(subchild)
				subchild.was_moved()
