extends ScrollContainer

func _ready() -> void:
	var all_feats = DatabaseLoader.json_dicts["feats"]
	for feat in all_feats:
		$ItemList.add_item(feat)

func _on_ItemList_item_activated(index: int) -> void:
	Signals.emit_signal("feat_info_requested", $ItemList.get_item_text(index))

func _on_AddToFeats_button_up() -> void:
	var selected_ind = $ItemList.get_selected_items()
	if selected_ind.empty():
		return
	selected_ind = selected_ind[0]
	var feat_str = $ItemList.get_item_text(selected_ind)
	Signals.emit_signal("add_feat", feat_str)
