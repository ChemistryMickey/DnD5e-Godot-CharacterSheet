extends HBoxContainer

var database : Dictionary
@onready var background_list = []

func _ready() -> void:
	database = DatabaseLoader.json_dicts["backgrounds"]
	for background in database:
		background_list.append(background)
	background_list.sort()
	for background in background_list:
		$OptionButton.add_item(background)

func _on_OptionButton_item_selected(index: int) -> void:
	var background = database[$OptionButton.get_item_text(index)]
	var background_string = "%s\n\nSource: %s\n" % [background["Description"], background["Source"]]
	if not background["Skill Proficiencies"].is_empty():
		background_string += "Skills: \n"
		for skill in background["Skill Proficiencies"]:
			background_string += "\t%s\n" %skill
	if not background["Tool Proficiencies"].is_empty():
		background_string += "Tool Proficiencies: \n"
		for skill in background["Tool Proficiencies"]:
			background_string += "\t%s\n" %skill
	background_string += "Languages: %s\n" % background["Languages"]
	if not background["Equipment"].is_empty():
		background_string += "Equipment: \n"
		for skill in background["Equipment"]:
			background_string += "\t%s\n" %skill
	if not background["Variants"].is_empty():
		background_string += "\nVariants: \n"
		for skill in background["Variants"]:
			background_string += "\t%s: \n\t\t%s\n" % [skill, background["Variants"][skill]]
	if not background["Features"].is_empty():
		background_string += "\nFeatures: \n"
		for skill in background["Features"]:
			background_string += "\t%s: \n%s\n" % [skill, background["Features"][skill]]
	Signals.emit_signal("emit_background_string", background_string)
