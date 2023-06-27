extends ItemList

func _ready() -> void:
	if Signals.connect("feats_updated", self, "update_feat_list"): 
		print("Unable to connect to feats_updated!")

func update_feat_list(feat_list : Array):
	self.clear()
	for feat in feat_list:
		self.add_item(feat)
		var ind = self.get_item_count() - 1
		var tool_tip_text = DatabaseLoader.parse_list(DatabaseLoader.json_dicts["feats"][feat]["content"])
		self.set_item_tooltip(ind, tool_tip_text)
