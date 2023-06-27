extends Control

var current_character_path : String = ""
var sheet_dict : Dictionary

onready var character_sheet = preload("res://src/UI/CharacterSheet.tscn")

func _ready() -> void:
	Signals.connect("save_character_creator", self, "finish_cc")
	
func finish_cc():
	save_current_sheet()
	yield($SaveFile, "file_selected")
	
	var new_charactersheet = character_sheet.instance()
	new_charactersheet.current_character_path = current_character_path
	new_charactersheet.load_sheet(current_character_path)
	$root.add_child(new_charactersheet)	
	self.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("save"):
		save_current_sheet()
	if event.is_action_pressed("quit"):
		Signals.emit_signal("show_confirmation", "quit_to_desktop")
	if event.is_action_pressed("options"):
		Signals.emit_signal("show_options")
		
func save_current_sheet():
	if current_character_path == "":
		$SaveFile.popup_centered()
		yield($SaveFile, "file_selected")
		
	var save_filename = current_character_path
	Debug.debug_print("Saving current sheet %s..." % save_filename)

	sheet_dict = {} #clear the sheet dict to prevent unintended entry persistence

	var save_game = File.new()
	save_game.open(save_filename, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		for key in node_data:
			sheet_dict[key] = node_data[key]
		
	save_game.store_string(JSON.print(sheet_dict))
	save_game.close()
	$SaveFlash/AnimationPlayer.play("flash") 


func _on_SaveFile_file_selected(path: String) -> void:
	current_character_path = path
