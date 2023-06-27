extends HBoxContainer

func _on_ExpAmountEdit_text_changed(_new_text: String) -> void:
	Signals.emit_signal("exp_changed")
	
func _on_ExpAmountEdit_text_entered(_new_text: String) -> void:
	Signals.emit_signal("exp_changed")

func save():
	var save_dict = {
		"Timestamp" : $IRLEdit.text,
		"Exp" : $ExpAmountEdit.text
	}
	
	return save_dict
	
func load_sheet(entry):
	$IRLEdit.text = entry["Timestamp"]
	$ExpAmountEdit.text = entry["Exp"]
	
