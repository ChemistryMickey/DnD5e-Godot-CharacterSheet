extends CheckButton
class_name StatusButton
	
func _toggled(button_pressed: bool) -> void:
	if button_pressed:
		Debug.debug_print("Overriding status button color on %s" % self.text)
		self.add_color_override("font_color", Color(1, 0, 0))
	else:
		Debug.debug_print("Removing status button color override")
		self.add_color_override("font_color", get_color("font_color", "Label"))
