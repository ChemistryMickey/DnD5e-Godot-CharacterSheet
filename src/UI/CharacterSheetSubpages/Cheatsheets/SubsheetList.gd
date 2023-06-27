extends ItemList

var current_cheatsheet = ""

func _ready() -> void:
	Signals.connect("request_subcheatsheet", self, "update_list")
	
func update_list(cheatsheet_in):
	self.clear()
	current_cheatsheet = cheatsheet_in
	for entry in DatabaseLoader.cheatsheets[current_cheatsheet]:
		self.add_item(entry)
		
	# Account for cheatsheets with no sub-sheets
	if self.get_item_count() == 0:
		Signals.emit_signal("cheatsheet_info_requested", current_cheatsheet, "")

func _on_SubsheetList_item_activated(index: int) -> void:
	var info_requested = self.get_item_text(index)
	Signals.emit_signal("cheatsheet_info_requested", current_cheatsheet, info_requested)
