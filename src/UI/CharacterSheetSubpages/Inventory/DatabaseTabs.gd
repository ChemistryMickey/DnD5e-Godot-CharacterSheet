extends TabContainer

var double_click_list_template = preload("res://src/UI/CharacterSheetSubpages/Inventory/DoubleClickList.tscn")
var label_edit_couple = load("res://src/UI/CharacterSheetSubpages/Inventory/LabelEditCouple.tscn")

func _ready() -> void:
	Signals.connect("display_item_database_info", Callable(self, "create_item_display"))
	var item_database = DatabaseLoader.json_dicts["item_database"]
	for item_class in item_database:
		var new_hbox = make_expansive(HBoxContainer.new())
		new_hbox.name = item_class
		
		var scroll = make_expansive(ScrollContainer.new())
		var database = double_click_list_template.instantiate()
		database.name = "%s List" % item_class
		
		scroll.add_child(database)
		new_hbox.add_child(scroll)
		
		prepare_item_hbox(item_database, database)
		self.add_child(new_hbox)

func create_item_display(item_str : String):
	if item_str.count("===") > 0:
		return;
	
	# Get item dictionary entry
	var item_database = DatabaseLoader.json_dicts["item_database"]
	var dict_entry : Dictionary = Utilities.find_in_dictionary(item_database, item_str)
	assert(not dict_entry.is_empty()) #Revel in your mistakes
	
	for child in self.get_children():
		for subchild in child.get_children():
			if subchild.name.count("item_info_block") >= 1:
				subchild.queue_free()
	
	# Get hbox
	for child in self.get_children():
		if child is HBoxContainer and child.is_visible():
			var info_box = make_expansive(VBoxContainer.new())
			info_box.name = "item_info_block"
			for info in dict_entry:
				if info != "Contents":
					var info_line = label_edit_couple.instantiate()
					info_line.set_props("%s: " % info, String(dict_entry[info]))
					info_box.add_child(info_line)
				else:
					for idx in dict_entry["Contents"].size():
						var info_line = label_edit_couple.instantiate()
						var item_quant_str = "%dx %s" % [dict_entry["Contents"][idx]["Quantity"],
														 dict_entry["Contents"][idx]["Item"]]
						info_line.set_props("Contents[%d]" % idx, item_quant_str)
						info_box.add_child(info_line)				
			child.add_child(info_box)
			break
	
	# Populate those label/entry pairs
	pass

func prepare_item_hbox(item_database, item_list : ItemList):
	var cat_sep = '==========='
	var sortable_list = []
	if item_list.name == "Armour List":
		for armour_class in item_database["Armour"]:
			item_list.add_item("%s %s" % [cat_sep, armour_class], null, false)
			for item in item_database["Armour"][armour_class]:
				sortable_list.append(item)
			sortable_list.sort()
			for item in sortable_list:
				item_list.add_item(item)
			sortable_list.clear()
		return
	elif item_list.name == "Weapons List":
		for weapon_class in item_database["Weapons"]:
			item_list.add_item("%s %s" % [cat_sep, weapon_class], null, false)
			for item in item_database["Weapons"][weapon_class]:
				sortable_list.append(item)
			sortable_list.sort()
			for item in sortable_list:
				item_list.add_item(item)
			sortable_list.clear()
		return
	elif item_list.name == "Adventuring Gear List":
		for item in item_database["Adventuring Gear"]:
			sortable_list.append(item)
		sortable_list.sort()
		for item in sortable_list:
			item_list.add_item(item)
		sortable_list.clear()
		return
	elif item_list.name == "Tools List":
		for tool_class in item_database["Tools"]:
			item_list.add_item("%s %s" % [cat_sep, tool_class], null, false)
			for item in item_database["Tools"][tool_class]:
				sortable_list.append(item)
			sortable_list.sort()
			for item in sortable_list:
				item_list.add_item(item)
			sortable_list.clear()
		return
	elif item_list.name == "Kits List":
		for item in item_database["Kits"]:
			item_list.add_item(item)
		return
	elif item_list.name == "Mounts and Vehicles List":
		for item in item_database["Mounts and Vehicles"]:
			sortable_list.append(item)
		sortable_list.sort()
		for item in sortable_list:
			item_list.add_item(item)
		sortable_list.clear()
		return
	elif item_list.name == "Trade Goods List":
		for item in item_database["Trade Goods"]:
			sortable_list.append(item)
		sortable_list.sort()
		for item in sortable_list:
			item_list.add_item(item)
		sortable_list.clear()
		return
	elif item_list.name == "Food and Drink List":
		for item in item_database["Food and Drink"]:
			sortable_list.append(item)
		sortable_list.sort()
		for item in sortable_list:
			item_list.add_item(item)
		sortable_list.clear()
		return

func make_expansive(container):
	container.size_flags_horizontal = container.SIZE_EXPAND_FILL
	container.size_flags_vertical = container.SIZE_EXPAND_FILL
	return container
