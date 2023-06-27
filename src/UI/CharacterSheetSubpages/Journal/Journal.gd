extends VBoxContainer

var journal_entry_template = preload("res://src/UI/CharacterSheetSubpages/Journal/JournalEntry.tscn")

onready var entry_box = $Entries/JournalEntries

func _on_NewEntry_button_up() -> void:
	var cur_date = Time.get_date_string_from_system()
	var new_entry = journal_entry_template.instance()
	new_entry.size_flags_vertical = new_entry.SIZE_EXPAND_FILL
	var entry_IRL_timestamp = new_entry.get_child(0).get_child(0)
	entry_IRL_timestamp.text = cur_date
	entry_box.add_child(new_entry)


func _on_RemoveLastEntry_button_up() -> void:
	if entry_box.get_child_count() > 0:
		entry_box.get_child(entry_box.get_child_count()-1).queue_free()
