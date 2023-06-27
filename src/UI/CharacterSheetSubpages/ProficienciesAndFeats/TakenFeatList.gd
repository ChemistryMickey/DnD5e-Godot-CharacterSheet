extends ItemList

func _ready() -> void:
	if Signals.connect("add_feat", self, "add_feat"): print("Unable to add feat!")
	
func add_feat(feat : String):
	var cur_items = []
	for idx in self.get_item_count():
		cur_items.append(self.get_item_text(idx))
		
	self.clear()
	cur_items.append(feat)
	cur_items.sort()
	for item in cur_items:
		self.add_item(item)
	Signals.emit_signal("feats_updated", cur_items)

func save():
	var save_dict = {"Feats" : []}
	for idx in self.get_item_count():
		save_dict["Feats"].append(self.get_item_text(idx))
	return save_dict
	
func load_sheet(save_dict):
	self.clear()
	for feat in save_dict["Feats"]:
		self.add_item(feat)
	Signals.emit_signal("feats_updated", save_dict["Feats"])

func _on_RemoveFeat_button_up() -> void:
	var feats_to_remove = self.get_selected_items()
	if feats_to_remove.empty():
		return
	self.remove_item(feats_to_remove[0])

func _on_ClearFeats_button_up() -> void:
	self.clear()

func _on_TakenFeatList_item_activated(index: int) -> void:
	Signals.emit_signal("feat_info_requested", self.get_item_text(index))
