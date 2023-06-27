extends Control

onready var state2 = $TabContainer/Summary/Summary/Right/State2
onready var tab_container = $TabContainer
onready var spellbook = $TabContainer/Spellbook
onready var save_dialog = $SaveFile

export (String) var current_character_path = ""

var sheet_dict : Dictionary
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("save"):
		save_current_sheet()
	if event.is_action_pressed("save_as"):
		current_character_path = ""
		save_current_sheet()
	if event.is_action_pressed("load"):
		load_sheet()
	if event.is_action_pressed("quit"):
		Signals.emit_signal("show_confirmation", "quit_to_desktop")
	if event.is_action_pressed("options"):
		Signals.emit_signal("show_options")
	if event.is_action_pressed("notes"):
		Signals.emit_signal("show_notes")
	if event.is_action_pressed("new_character"):
		Signals.emit_signal("show_confirmation", "new_character")
		
func _on_SaveFile_file_selected(path: String) -> void:
	current_character_path = path

func _on_LoadFile_file_selected(path: String) -> void:
	current_character_path = path
	
func open_quit_dialogue():
	$ConfirmationDialog.popup_centered()
	yield($ConfirmationDialog, "confirmed")
		
func save_current_sheet():
	if current_character_path == "":
		save_dialog.popup_centered()
		yield(save_dialog, "file_selected")
		
	var save_filename = current_character_path
	Debug.debug_print("Saving current sheet %s..." % save_filename)

	sheet_dict = {} #clear the sheet dict to prevent unintended entry persistence

	var save_game = File.new()
	save_game.open(save_filename, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save"):
			#print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		for key in node_data:
			sheet_dict[key] = node_data[key]
		
	save_game.store_string(JSON.print(sheet_dict))
	save_game.close()
	$SaveFlash/AnimationPlayer.play("flash")

func load_sheet(var path : String = ""):
	if path == "":
		$LoadFile.popup_centered()
		yield($LoadFile, "file_selected")
	else:
		current_character_path = path
	
	var save_game = File.new()
	if not save_game.file_exists(current_character_path):
		return # Error! We don't have a save to load.

	save_game.open(current_character_path, File.READ)

	var conts = save_game.get_as_text()
	save_game.close()
	
	sheet_dict = JSON.parse(conts).result
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if !node.has_method("load_sheet"):
			#print("persistent node '%s' is missing a load() function, skipped" % node.name)
			continue
			
		node.call("load_sheet", sheet_dict)
	
func find_node_based_on_text(root_node, text_to_find : String):
	# Only finds labels and buttons right now
	for node in root_node.get_children():
		if node is Label or node is Button:
			if node.text == text_to_find:
				return node

func _on_Save_button_up() -> void:
	$OptionDialogue.hide()
	save_current_sheet()

func _on_Load_button_up() -> void:
	$OptionDialogue.hide()
	load_sheet()

func _on_SaveAs_button_up() -> void:
	current_character_path = ""
	save_current_sheet()
	$OptionDialogue.hide()
