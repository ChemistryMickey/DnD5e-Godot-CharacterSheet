extends VBoxContainer

var stats = ["STR", "DEX", "CON", "INT", "WIS", "CHA"]
var stat_line_template = preload("res://src/UI/CharacterSheetSubpages/Summary/StatLine.tscn")
var stat_line_script = load("res://src/UI/CharacterSheetSubpages/Summary/StatLine.gd")

func _ready() -> void:
	for stat in stats:
		var new_stat_line = stat_line_template.instantiate()
		for child in new_stat_line.get_children():
			if child is LineEdit:
				child.size_flags_horizontal = child.SIZE_EXPAND_FILL
		new_stat_line.stat_str = stat
		new_stat_line.set_script(stat_line_script)
		self.add_child(new_stat_line)
		
func save():
	var save_dict = {"Stats" : {}}
	var children = self.get_children()
	var stat_iter = 0
	for idx in range(children.size()):
		var cur_child = children[idx]
		if cur_child is StatLine:
			save_dict["Stats"][stats[stat_iter]] = cur_child.save()
			stat_iter += 1
	return save_dict
	
func load_sheet(save_dict):
	var children = self.get_children()
	var stat_iter = 0
	for idx in range(children.size()):
		var cur_child = children[idx]
		if cur_child is StatLine:
			cur_child.load_sheet(save_dict["Stats"][stats[stat_iter]])
			stat_iter += 1


