extends HBoxContainer

var NPC_line = preload("res://src/UI/CharacterSheetSubpages/CharacterDevelopment/NPC_entry.tscn")

func save():
	var save_dict = {
		"Backstory" : $Left/Backstory.text,
		"Personality" : $Left/Personality.text,
		"Motivation" : $Left/Motivation.text,
		"NPCs": {}
	}
	for child in $Right/NPC_scroll/NPCs.get_children():
		if child is NPC_entry:
			save_dict["NPCs"][child.NPC_name] = child.save()
	return save_dict
	
func load_sheet(save_dict):
	$Left/Backstory.text = save_dict["Backstory"]
	$Left/Personality.text = save_dict["Personality"]
	$Left/Motivation.text = save_dict["Motivation"]
	
	for NPC in save_dict["NPCs"].keys():
		var new_npc: NPC_entry = NPC_line.instantiate()
		new_npc.load_save(NPC, save_dict["NPCs"][NPC])
		$Right/NPC_scroll/NPCs.add_child(new_npc)

#========================================
class NPC_sorter:
	static func sort_by_name(a, b):
		if a.NPC_name < b.NPC_name:
			return true
		return false
	static func sort_by_where(a, b):
		if a.where < b.where:
			return true
		return false
	static func sort_by_when(a, b):
		if a.when < b.when:
			return true
		return false

func _on_sort_np_cs_button_up():
	var children = $Right/NPC_scroll/NPCs.get_children()
	for child in children:
		$Right/NPC_scroll/NPCs.remove_child(child)
		
	children.sort_custom(NPC_sorter.sort_by_name)
	for child in children:
		$Right/NPC_scroll/NPCs.add_child(child)

func _on_add_npc_button_up():
	var new_NPC = NPC_line.instantiate()
	new_NPC.update_when(Time.get_date_string_from_system())
	$Right/NPC_scroll/NPCs.add_child(new_NPC)

func _on_remove_np_cs_button_up():
	for child in $Right/NPC_scroll/NPCs.get_children():
		if child is NPC_entry:
			if child.selected_for_delete:
				child.queue_free()

func _on_sort_where_np_cs_button_up():
	var children = $Right/NPC_scroll/NPCs.get_children()
	for child in children:
		$Right/NPC_scroll/NPCs.remove_child(child)
		
	children.sort_custom(NPC_sorter.sort_by_where)
	for child in children:
		$Right/NPC_scroll/NPCs.add_child(child)


func _on_sort_when_np_cs_button_up():
	var children = $Right/NPC_scroll/NPCs.get_children()
	for child in children:
		$Right/NPC_scroll/NPCs.remove_child(child)
		
	children.sort_custom(NPC_sorter.sort_by_when)
	for child in children:
		$Right/NPC_scroll/NPCs.add_child(child)
