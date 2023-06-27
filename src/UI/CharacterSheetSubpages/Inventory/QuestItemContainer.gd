extends VBoxContainer

var inventory_entry_template = preload("res://src/UI/CharacterSheetSubpages/Inventory/InventoryEntry.tscn")
var num_inventory_entries = 0

func _on_AddItem_button_up() -> void:
	var new_entry = inventory_entry_template.instance()
	new_entry.name = "inventory_entry_" + str($"/root/Utilities".num_inventory_entries)
	$"/root/Utilities".num_inventory_entries += 1
	self.add_child(new_entry)

func _on_DeleteSelected_button_up() -> void:
	for child in self.get_children():
		if child.selected_for_delete:
			child.queue_free()

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

func _on_SortQuestItems_button_up() -> void:
	var children = self.get_children()
	for child in children:
		self.remove_child(child)
		
	children.sort_custom(Inventory_sorter, "sort_by_name")
	for child in children:
		self.add_child(child)
		
func save():
	var save_dict = {"Quest Items" : []}
	for child in self.get_children():
		save_dict["Quest Items"].append(child.save())
	return save_dict
	
func load_sheet(save_dict):
	for child in self.get_children():
		child.queue_free()
	if save_dict.has("Quest Items"):
		for entry in save_dict["Quest Items"]:
			var new_entry = inventory_entry_template.instance()
			new_entry.load_sheet(entry)
			new_entry.name = "inventory_entry_" + str($"/root/Utilities".num_inventory_entries)
			$"/root/Utilities".num_inventory_entries += 1
			self.add_child(new_entry)
		Signals.emit_signal("update_total_weights_and_values")



