extends HBoxContainer

func set_props(label_str : String, text_str : String) -> void:
	$Label.text = "%s: " % label_str
	$TextEdit.text = text_str
