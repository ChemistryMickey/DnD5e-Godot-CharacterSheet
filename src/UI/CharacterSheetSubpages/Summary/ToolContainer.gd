extends VBoxContainer

@onready var tool_dict = DatabaseLoader.json_dicts["tools"]

func _ready():
	for tool_class in tool_dict:
		var label = Label.new()
		label.text = tool_class
		self.add_child(label)

		for tool_ in tool_dict[tool_class]:
			var button = CheckButton.new()
			button.text = tool_
			self.add_child(button)

func save():
	var save_dict = {"Tool Proficiencies" : {}}
	for child in self.get_children():
		if child is CheckButton:
			save_dict["Tool Proficiencies"][child.text] = child.button_pressed
	return save_dict
	
func load_sheet(save_dict):
	for child in self.get_children():
		if child is CheckButton:
			child.button_pressed = save_dict["Tool Proficiencies"][child.text]
