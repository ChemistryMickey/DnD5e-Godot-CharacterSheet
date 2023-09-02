extends Control
class_name InventoryEntry

# Interface
@export var selected_for_delete: bool = false
@export var equipped: bool = false
@export var item_name: String = ""
@export var val_per_unit: String = ""
@export var denomination: int = 0
@export var weight_per_unit: String = ""
@export var quantity: String = ""

func _ready() -> void:
	Signals.connect("item_info_changed", Callable(self, "update_item_info"))
	Signals.connect("item_info_changed", Callable(self, "add_color_to_info_button"))
	add_color_to_info_button(self.name, "")
	
func _on_ItemName_text_changed(new_text: String) -> void:
	item_name = new_text
		
func _on_CheckBox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_for_delete = true
		$SelectedFilter.show()
	else:
		selected_for_delete = false
		$SelectedFilter.hide()

func _on_InfoRequest_button_up() -> void:
	Signals.emit_signal("display_item_info", self.name, $HBoxContainer/ItemName.text, $InfoContainer.text)

func _on_ValuePerUnit_text_changed(new_text: String) -> void:
	val_per_unit = new_text
	Signals.emit_signal("update_total_weights_and_values")

func _on_Denomination_item_selected(index: int) -> void:
	denomination = index
	Signals.emit_signal("update_total_weights_and_values")

func _on_WeightPerUnit_text_changed(new_text: String) -> void:
	weight_per_unit = new_text
	Signals.emit_signal("update_total_weights_and_values")

func _on_Quantity_text_changed(new_text: String) -> void:
	quantity = new_text
	Signals.emit_signal("update_total_weights_and_values")

func _on_Equip_toggled(button_pressed: bool) -> void:
	if button_pressed:
		equipped = true
		Signals.emit_signal("equip_item", $HBoxContainer/ItemName.text)
	else:
		equipped = false
		Signals.emit_signal("unequip_item", $HBoxContainer/ItemName.text)
		
func update_item_info(node_name, item_info : String):
	if node_name == self.name:
		$InfoContainer.text = item_info
		
func add_color_to_info_button(node_name, _info_text):
	if self.name == node_name and not $InfoContainer.text.is_empty():
		$HBoxContainer/InfoRequest.self_modulate = Color(0, 1, 0)
	elif self.name == node_name:
		$HBoxContainer/InfoRequest.self_modulate = Color(1, 0, 0)
		
func set_name_and_quantity(name_in : String, item_quantity : String):
	$HBoxContainer/ItemName.text = name_in
	item_name = name_in
	$HBoxContainer/Quantity.text = item_quantity
	quantity = item_quantity
		
func save():
	var save_dict = {
		"Name" : $HBoxContainer/ItemName.text,
		"Value/Unit" : $HBoxContainer/ValuePerUnit.text,
		"Denomination" : $HBoxContainer/Denomination.selected,
		"Weight/Unit" : $HBoxContainer/WeightPerUnit.text,
		"Quantity" : $HBoxContainer/Quantity.text,
		"Equipped" : $HBoxContainer/Equip.button_pressed,
		"Info" : $InfoContainer.text
	}
	return save_dict
	
func load_sheet(save_dict):
	$HBoxContainer/ItemName.text = save_dict["Name"]
	$HBoxContainer/ValuePerUnit.text = save_dict["Value/Unit"]
	$HBoxContainer/Denomination.selected = save_dict["Denomination"]
	$HBoxContainer/WeightPerUnit.text = save_dict["Weight/Unit"]
	$HBoxContainer/Quantity.text = save_dict["Quantity"]
	$HBoxContainer/Equip.button_pressed = save_dict["Equipped"]
	
	item_name = save_dict["Name"]
	val_per_unit = save_dict["Value/Unit"]
	denomination = save_dict["Denomination"]
	weight_per_unit = save_dict["Weight/Unit"]
	quantity = save_dict["Quantity"]
	equipped = save_dict["Equipped"]
	
	$InfoContainer.text = save_dict["Info"]
	add_color_to_info_button(self.name, $InfoContainer.text)
