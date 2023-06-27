extends HBoxContainer

func _on_Finish_button_up() -> void:
	Signals.emit_signal("save_character_creator")
