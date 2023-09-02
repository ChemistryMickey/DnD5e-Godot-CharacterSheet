extends Control

var inventory_entry_template = preload("res://src/UI/CharacterSheetSubpages/Inventory/InventoryEntry.tscn")

func _ready() -> void:
	Signals.connect("display_item_info", Callable(self, "update_item_description"))
	Signals.connect("update_total_weights_and_values", Callable(self, "update_total_weights_and_values"))

func _on_ItemDatabase_button_up() -> void:
	Signals.emit_signal("show_item_database")

func update_item_description(node_name, item_name : String, info_str : String):
	$InventoryContainer/Right/ItemDescription.text = info_str
	$InventoryContainer/Right/ItemDescription.target_node = node_name
	$InventoryContainer/Right/HBoxContainer/CustomInfoItemName.text = item_name

func update_total_weights_and_values():
	var total_weight = 0
	var total_value = 0
	var denomination_map = [1.0/100.0, 1.0/10.0, 1.0/2.0, 1.0, 10.0]
	for child in get_tree().get_nodes_in_group("InventoryEntry"):
		Debug.debug_print("%d" % child.denomination)
		total_value += float(child.val_per_unit) * float(child.quantity) * \
						denomination_map[child.denomination]
		total_weight += float(child.weight_per_unit) * float(child.quantity)
	$InventoryContainer/Inventory/Summary/TotalValue.text = str(total_value)
	$InventoryContainer/Inventory/Summary/TotalWeight.text = str(total_weight)
