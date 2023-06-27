extends MenuButton

func _ready() -> void:
	var popup = get_children()[0]
	var database = DatabaseLoader.json_dicts["races"]
	for entry in database:
		popup.add_check_item(entry)
		
	popup.connect("id_pressed", self, "update_choice_text")
	
func update_choice_text(choice_ind : int):
	self.text = self.get_popup().get_item_text(choice_ind)
	Signals.emit_signal("race_changed", self.text)
