extends HBoxContainer

@export var is_empty: bool = true

func _on_TransactionEdit_text_changed(_new_text: String) -> void:
	Signals.emit_signal("money_changed")

func _on_cpEdit_text_changed(_new_text: String) -> void:
	Signals.emit_signal("money_changed")

func _on_spEdit_text_changed(_new_text: String) -> void:
	Signals.emit_signal("money_changed")

func _on_epEdit_text_changed(_new_text: String) -> void:
	Signals.emit_signal("money_changed")

func _on_gpEdit_text_changed(_new_text: String) -> void:
	Signals.emit_signal("money_changed")

func _on_ppEdit_text_changed(_new_text: String) -> void:
	Signals.emit_signal("money_changed")
	
func set_props(trans_text : String, price_arr : Array):
	$TransactionEdit.text = trans_text
	var current_prices = [
		$cpEdit,
		$spEdit,
		$epEdit,
		$gpEdit,
		$ppEdit
	]
	for idx in price_arr.size():
		current_prices[idx].text = String(price_arr[idx])
	Signals.emit_signal("money_changed")

func save():
	var save_dict = {
		"Timestamp" : $IRLEdit.text,
		"Transaction" : $TransactionEdit.text,
		"CP" : $cpEdit.text,
		"SP" : $spEdit.text,
		"EP" : $epEdit.text,
		"GP" : $gpEdit.text,
		"PP" : $ppEdit.text
	}
	
	return save_dict
	
func load_sheet(entry):
	$IRLEdit.text = entry["Timestamp"]
	$TransactionEdit.text = entry["Transaction"]
	$cpEdit.text = entry["CP"]
	$spEdit.text = entry["SP"]
	$epEdit.text = entry["EP"]
	$gpEdit.text = entry["GP"]
	$ppEdit.text = entry["PP"]

