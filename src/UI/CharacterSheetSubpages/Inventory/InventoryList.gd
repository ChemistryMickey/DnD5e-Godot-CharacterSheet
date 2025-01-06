extends VBoxContainer

var inventory_entry_template = preload("res://src/UI/CharacterSheetSubpages/Inventory/InventoryEntry.tscn")
func _ready() -> void:
	Signals.connect("add_item_to_inventory", Callable(self, "add_item"))

class Inventory_sorter:
	static func sort_by_name(a, b):
		# Priorize equipped items
		if a.equipped and not b.equipped:
			return true
		elif not a.equipped and b.equipped:
			return false
		elif a.item_name < b.item_name:
			return true
		return false
		
func _on_AddItem_button_up() -> void:
	var new_entry = inventory_entry_template.instantiate()
	new_entry.name = "inventory_entry_" + str($"/root/Utilities".num_inventory_entries)
	$"/root/Utilities".num_inventory_entries += 1
	self.add_child(new_entry)
		
func _on_DeleteSelected_button_up() -> void:
	for child in self.get_children():
		if child.selected_for_delete:
			child.free()
	Signals.emit_signal("update_total_weights_and_values")

func _on_SortInventory_button_up() -> void:
	var children = self.get_children()
	for child in children:
		self.remove_child(child)
		
	children.sort_custom(Callable(Inventory_sorter, "sort_by_name"))
	for child in children:
		self.add_child(child)

func add_item(item_name : String, quantity : String):
	var new_entry = inventory_entry_template.instantiate()
	new_entry.set_name_and_quantity(item_name, quantity)
	new_entry.name = "inventory_entry_" + str($"/root/Utilities".num_inventory_entries)
	$"/root/Utilities".num_inventory_entries += 1
	self.add_child(new_entry)

func save():
	var save_dict = {"Items" : []}
	for child in self.get_children():
		save_dict["Items"].append(child.save())
	return save_dict
	
func load_sheet(save_dict):
	for child in self.get_children():
		child.free()
	for entry in save_dict["Items"]:
		var new_entry = inventory_entry_template.instantiate()
		new_entry.load_sheet(entry)
		new_entry.name = "inventory_entry_" + str($"/root/Utilities".num_inventory_entries)
		$"/root/Utilities".num_inventory_entries += 1
		self.add_child(new_entry)
	Signals.emit_signal("update_total_weights_and_values")
