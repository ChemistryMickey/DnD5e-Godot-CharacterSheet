extends VBoxContainer

var skill_list = ["Acrobatics", "Animal Handling", "Arcana", "Athletics", "Deception", 
"History", "Insight", "Intimidation", "Investigation", "Medicine",
"Nature", "Perception", "Performance", "Persuasion", "Religion",
"Sleight of Hand", "Stealth", "Survival"]

var stat_list = ["DEX", "WIS", "INT", "STR", "CHA", "INT", "WIS", 
"CHA", "INT", "WIS", "INT", "WIS", "CHA", "CHA", "INT", "DEX", "DEX", "WIS"]

var skill_line_template = preload("res://src/UI/CharacterSheetSubpages/Summary/SkillLine.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for idx in range(stat_list.size()):
		var new_skill_line = skill_line_template.instantiate()
		new_skill_line.stat = stat_list[idx]
		new_skill_line.skill = skill_list[idx]
		
		new_skill_line.size_flags_horizontal = new_skill_line.SIZE_EXPAND_FILL
		for child in new_skill_line.get_children():
			if child is LineEdit:
				child.size_flags_horizontal = child.SIZE_EXPAND_FILL
		self.add_child(new_skill_line)

func save():
	var save_dict = {"Skills" : {}}
	var children = self.get_children()
	var skill_iter = 0
	for idx in range(children.size()):
		if children[idx].has_method("save"):
			save_dict["Skills"][skill_list[skill_iter]] = children[idx].save()
			skill_iter += 1
	return save_dict
	
func load_sheet(save_dict):
	var children = self.get_children()
	var skill_iter = 0
	for idx in range(children.size()):
		if children[idx] is SkillLine:
			children[idx].stat = stat_list[skill_iter]
			children[idx].skill = skill_list[skill_iter]
			children[idx].load_sheet(save_dict["Skills"][skill_list[skill_iter]])
			skill_iter += 1

