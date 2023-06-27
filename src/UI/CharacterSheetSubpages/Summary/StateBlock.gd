extends GridContainer

onready var states_dict : Dictionary = DatabaseLoader.json_dicts["conditions"]

var button_script = preload("res://src/UI/CharacterSheetSubpages/Summary/StatusButton.gd")

func _ready() -> void:
	for state in states_dict.keys():
		var new_control : Control
		if state != "Exhaustion":
			new_control = CheckButton.new()
			new_control.text = state
			new_control.align = 1
			new_control.size_flags_horizontal = CheckButton.SIZE_EXPAND_FILL
			new_control.set_script(button_script)
		else:
			new_control = HBoxContainer.new()
			var label = Label.new()
			label.text = "Exhaustion: "
			new_control.add_child(label)
			
			var lineEdit = LineEdit.new()
			lineEdit.size_flags_horizontal = LineEdit.SIZE_EXPAND_FILL
			lineEdit.align = LineEdit.ALIGN_RIGHT
			new_control.add_child(lineEdit)
		
		new_control.hint_tooltip = states_dict[state]
		
		
		self.add_child(new_control)
		
func save():
	var save_dict = {"Conditions" : {}}
	var children = self.get_children()
	
	var state_list = []
	for state in states_dict:
		state_list.append(state)
		
	var status_iter = 0
	for child in children:
		if child is StatusButton:
			save_dict["Conditions"][state_list[status_iter]] = child.pressed
			status_iter += 1
		elif child is LineEdit:
			save_dict["Conditions"]["Exhaustion"] = child.text

	return save_dict
	
func load_sheet(save_dict):
	var children = self.get_children()
	
	var state_list = []
	for state in states_dict:
		state_list.append(state)
	
	var status_iter = 0
	for child in children:
		if child is StatusButton:
			child.pressed = save_dict["Conditions"][state_list[status_iter]]
			status_iter += 1
		elif child is LineEdit:
			child.text = save_dict["Conditions"]["Exhaustion"]
