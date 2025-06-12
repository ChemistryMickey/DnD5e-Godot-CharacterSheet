extends VBoxContainer

@export var item_type: String = ""
var item_str = ""

var inventory_entry_template = preload("res://src/UI/CharacterSheetSubpages/Inventory/InventoryEntry.tscn")
var num_inventory_entries = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.item_str = item_type + " Items"
	$HBoxContainer/Label.text = self.item_str
	$HBoxContainer/Sort.text = "Sort " + self.item_str
	
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

func _on_delete_selected_button_up() -> void:
	# NOTE: We don't decrement the item counter in case you didn't delete the last one.
	# This is to avoid accidentally colliding node names.
	# You won't have more items than max integers anyways
	for child in $ScrollBox/Items.get_children():
		if child.selected_for_delete:
			child.free()
	Signals.emit_signal("update_total_weights_and_values")

func _on_sort_button_up() -> void:
	var children = $ScrollBox/Items.get_children()
	for child in children:
		$ScrollBox/Items.remove_child(child)
		
	children.sort_custom(Callable(Inventory_sorter, "sort_by_name"))
	for child in children:
		$ScrollBox/Items.add_child(child)

func _on_add_item_button_up() -> void:
	var new_entry = inventory_entry_template.instantiate()
	new_entry.name = self.item_type + "_inventory_entry_" + str(num_inventory_entries)
	num_inventory_entries += 1
	$ScrollBox/Items.add_child(new_entry)

func save():
	var save_dict = {self.item_str: []}
	for child in $ScrollBox/Items.get_children():
		save_dict[self.item_str].append(child.save())
	return save_dict
	
func load_sheet(save_dict):
	for child in $ScrollBox/Items.get_children():
		child.free()
	if save_dict.has(self.item_str):
		for entry in save_dict[self.item_str]:
			var new_entry = inventory_entry_template.instantiate()
			new_entry.load_sheet(entry)
			new_entry.name = self.item_type + "_inventory_entry_" + str(num_inventory_entries)
			num_inventory_entries += 1
			$ScrollBox/Items.add_child(new_entry)
		Signals.emit_signal("update_total_weights_and_values")
