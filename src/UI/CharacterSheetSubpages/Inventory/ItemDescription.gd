extends TextEdit

@export var target_node = ""

func _on_ItemDescription_text_changed() -> void:
	Signals.emit_signal("item_info_changed", target_node, self.text)
