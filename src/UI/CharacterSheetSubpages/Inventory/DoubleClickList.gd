extends ItemList

func _on_ItemList_item_activated(index: int) -> void:
	Signals.emit_signal("display_item_database_info", self.get_item_text(index))
