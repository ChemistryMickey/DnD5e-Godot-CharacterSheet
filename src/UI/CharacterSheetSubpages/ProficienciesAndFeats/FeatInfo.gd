extends VBoxContainer

func _ready() -> void:
	if Signals.connect("feat_info_requested", Callable(self, "update_feat_info")):
		print("Unable to connect to feat_info_requested")
	
func update_feat_info(feat : String):
	var chosen_feat = DatabaseLoader.json_dicts["feats"][feat]
	$FeatName/LineEdit.text = feat
	$Prerequisites/LineEdit.text = chosen_feat["Prerequisite"]
	$Source/LineEdit.text = chosen_feat["Source"]
	
	# Process the rest of the content as newlined stuff
	var description_str = ""
	for line in chosen_feat["content"]:
		description_str += line
		description_str += "\n"
		
	$Effect/TextEdit.text = description_str
