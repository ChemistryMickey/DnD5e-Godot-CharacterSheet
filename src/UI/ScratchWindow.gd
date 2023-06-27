extends WindowDialog

func _ready():
	Signals.connect("show_notes", self, "toggle_self")
	
func toggle_self():
	if self.is_visible_in_tree():
		self.hide()
	else:
		self.show()
