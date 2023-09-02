extends Window

func _ready() -> void:
	Signals.connect("show_item_database", Callable(self, "toggle_self"))

func toggle_self():
	if self.visible:
		self.hide()
	else:
		self.show()

func get_currently_selected():
	# Get visible child
	for child in $VBoxContainer/DatabaseTabs.get_children():
		if child.is_visible():
			var scroll : ScrollContainer = child.get_child(0)
			var list : ItemList = scroll.get_child(0)
			var selected_ind = list.get_selected_items()[0]
			return list.get_item_text(selected_ind)
			
	return ""


func _on_Purchase_show_button_up() -> void:
	if $VBoxContainer/PurchaseBar.is_visible():
		$VBoxContainer/PurchaseBar.hide()
	else:
		$VBoxContainer/PurchaseBar.show()
		$VBoxContainer/AddBar.hide()

func _on_AddItem_button_up() -> void:
	if $VBoxContainer/AddBar.is_visible():
		$VBoxContainer/AddBar.hide()
	else:
		$VBoxContainer/PurchaseBar.hide()
		$VBoxContainer/AddBar.show()

func _on_AddBar_Cancel_button_up() -> void:
	$VBoxContainer/AddBar.hide()

func _on_PurchaseBar_Cancel_button_up() -> void:
	$VBoxContainer/PurchaseBar.hide()


func _on_AddItem_Confirm_button_up() -> void:
	# Get currently selected item
	var selected_item : String = get_currently_selected()
	
	# Get quantity
	var quantity = $VBoxContainer/AddBar/Quantity.text
	
	# Signal to add the item
	Signals.emit_signal("add_item_to_inventory", selected_item, quantity)
	$VBoxContainer/AddBar/Quantity.text = ""

func _on_Confirm_Purchase_button_up() -> void:
	var selected_item : String = get_currently_selected()
	var quantity = $VBoxContainer/PurchaseBar/Quantity.text
	var price = [	$VBoxContainer/PurchaseBar/cp.text, 
					$VBoxContainer/PurchaseBar/sp.text, 
					$VBoxContainer/PurchaseBar/ep.text,
					$VBoxContainer/PurchaseBar/gp.text,
					$VBoxContainer/PurchaseBar/pp.text]
	Signals.emit_signal("add_item_to_inventory", selected_item, quantity)
	Signals.emit_signal("add_purchase_entry", selected_item, quantity, price)
	$VBoxContainer/PurchaseBar/cp.text = ""
	$VBoxContainer/PurchaseBar/sp.text = ""
	$VBoxContainer/PurchaseBar/ep.text = ""
	$VBoxContainer/PurchaseBar/gp.text = ""
	$VBoxContainer/PurchaseBar/pp.text = ""
	$VBoxContainer/PurchaseBar/Quantity.text = ""
	$VBoxContainer/PurchaseBar.hide()



func _on_close_requested():
	self.hide()
