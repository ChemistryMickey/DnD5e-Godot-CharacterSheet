extends HBoxContainer

var journal_entry_template = preload("res://src/UI/CharacterSheetSubpages/Journal/JournalEntry.tscn")
var NPC_line = preload("res://src/UI/CharacterSheetSubpages/CharacterDevelopment/NPC_entry.tscn")

@onready var entry_box = $HSplitContainer/JournCont/Entries/JournalEntries
@onready var npc_cont = $HSplitContainer/NPCs/NPC_scroll/NPCs

func save():
	var save_dict = {
		"NPCs": {}
	}
	for child in npc_cont.get_children():
		if child is NPC_entry:
			save_dict["NPCs"][child.NPC_name] = child.save()
	return save_dict
	
func load_sheet(save_dict):
	for child in npc_cont.get_children():
		child.queue_free()
	
	for NPC in save_dict["NPCs"].keys():
		var new_npc: NPC_entry = NPC_line.instantiate()
		new_npc.load_save(NPC, save_dict["NPCs"][NPC])
		npc_cont.add_child(new_npc)

# ======== Journal Handling
func _on_NewEntry_button_up() -> void:
	var cur_date = Time.get_date_string_from_system()
	var new_entry = journal_entry_template.instantiate()
	new_entry.size_flags_vertical = new_entry.SIZE_EXPAND_FILL
	new_entry.set_irl_date(cur_date)
	entry_box.add_child(new_entry)


func _on_RemoveLastEntry_button_up() -> void:
	for entry in entry_box.get_children():
		if entry.is_selected:
			entry.queue_free()

# ======== NPC Handling

func _on_add_npc_pressed() -> void:
	var new_NPC = NPC_line.instantiate()
	new_NPC.update_when(Time.get_date_string_from_system())
	npc_cont.add_child(new_NPC)


func _on_remove_np_cs_pressed() -> void:
	for child in npc_cont.get_children():
		if child is NPC_entry:
			if child.selected_for_delete:
				child.queue_free()

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

func _on_sort_np_cs_pressed() -> void:
	var children = npc_cont.get_children()
	for child in children:
		npc_cont.remove_child(child)
		
	children.sort_custom(NPC_sorter.sort_by_name)
	for child in children:
		npc_cont.add_child(child)


func _on_sort_where_np_cs_pressed() -> void:
	var children = npc_cont.get_children()
	for child in children:
		npc_cont.remove_child(child)
		
	children.sort_custom(NPC_sorter.sort_by_where)
	for child in children:
		npc_cont.add_child(child)


func _on_sort_when_np_cs_pressed() -> void:
	var children = npc_cont.get_children()
	for child in children:
		npc_cont.remove_child(child)
		
	children.sort_custom(NPC_sorter.sort_by_when)
	for child in children:
		npc_cont.add_child(child)
