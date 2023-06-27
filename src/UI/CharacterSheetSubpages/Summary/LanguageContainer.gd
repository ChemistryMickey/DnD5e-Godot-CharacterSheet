extends VBoxContainer

onready var language_dict = DatabaseLoader.json_dicts["languages"]

func _ready():
	var lang_list = []
	for lang in language_dict:
		lang_list.append(lang)
	lang_list.sort()
	for lang in lang_list:
		var new_lang_button = CheckButton.new()
		new_lang_button.text = lang
		
		var help_text = "Spoken By: %s. Script Used: %s" % [language_dict[lang]["Typical Speakers"],
															language_dict[lang]["Script"]]
		new_lang_button.hint_tooltip = help_text
		self.add_child(new_lang_button)

func save():
	var save_dict = {"Languages" : {}}
	for child in self.get_children():
		save_dict["Languages"][child.text] = child.pressed
	return save_dict
	
func load_sheet(save_dict):
	for child in self.get_children():
		if save_dict["Languages"].has(child.text):
			child.pressed = save_dict["Languages"][child.text]
