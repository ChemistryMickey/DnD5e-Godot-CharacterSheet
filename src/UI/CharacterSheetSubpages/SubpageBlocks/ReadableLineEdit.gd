extends LineEdit
class_name ReadableLineEdit

func _ready() -> void:
	if self.connect("text_changed", self, "color_negatives"): print("Unable to color text!")
	if self.text.count("-") > 0:
		color_negatives(self.text)
	
func color_negatives(new_text : String):
	if new_text.count('-') > 0:
		self.add_color_override("font_color", Color(1, 0, 0))
	else:
		self.remove_color_override("font_color")
