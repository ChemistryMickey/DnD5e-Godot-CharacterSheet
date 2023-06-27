extends ItemList

func _ready() -> void:
	for entry in DatabaseLoader.cheatsheets:
		self.add_item(entry)

func _on_CheatSheetList_item_activated(index: int) -> void:
	var requested_cheatsheet = self.get_item_text(index)
	Signals.emit_signal("request_subcheatsheet", requested_cheatsheet)
