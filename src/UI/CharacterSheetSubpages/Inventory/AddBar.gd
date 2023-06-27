extends HBoxContainer

func _on_Cancel_button_up() -> void:
	$Quantity.text = ""
	self.hide()


func _on_AddItem_button_up() -> void:
	self.show()
