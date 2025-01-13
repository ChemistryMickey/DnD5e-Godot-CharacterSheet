extends MenuButton

signal class_updated

@export_enum("classes", "races", "conditions", "equipment",
						"feats", "spellcasting") var json_choice: String

var option_list = []


func _ready() -> void:
	get_popup().clear()
	# Make menu buttons for each class
	for key in DatabaseLoader.json_dicts[json_choice]:
		get_popup().add_item(key)
		option_list.append(key)

	var popup = get_children(true)[0]
	popup.connect("id_pressed", Callable(self, "update_choice_text"))

func update_choice_text(choice_ind: int) -> void:
	self.text = option_list[choice_ind]
	Debug.debug_print("Emitting updated choice text: %s" % option_list[choice_ind])
	Signals.emit_signal("class_updated", option_list[choice_ind])
