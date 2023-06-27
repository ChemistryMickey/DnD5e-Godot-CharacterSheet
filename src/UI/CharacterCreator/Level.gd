extends MenuButton

func _ready() -> void:
	var popup = get_children()[0]
	for i in range(1, 20):
		popup.add_check_item(String(i))
		
	popup.connect("id_pressed", self, "update_choice_text")
	
func update_choice_text(choice_ind : int):
	self.text = "Level %s" % String(choice_ind + 1)
