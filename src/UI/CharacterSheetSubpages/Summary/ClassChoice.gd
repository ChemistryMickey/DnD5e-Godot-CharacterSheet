extends MenuButton

export (String, "classes", "races", "conditions", "equipment", 
						"feats", "spellcasting") var json_choice
var option_list = []

signal class_updated

func _ready() -> void:
	get_popup().clear()
	# Make menu buttons for each class
	for key in DatabaseLoader.json_dicts[json_choice]:
		get_popup().add_item(key)
		option_list.append(key)

	var popup = get_children()[0]
	popup.connect("id_pressed", self, "update_choice_text")
	
func update_choice_text(choice_ind : int) -> void:
	self.text = option_list[choice_ind]
	if Debug.DEBUG_PRINT: print("Emitting updated choice text: %s" % option_list[choice_ind])
	emit_signal("class_updated", option_list[choice_ind])

