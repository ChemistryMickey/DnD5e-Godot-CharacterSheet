extends Window

func _ready():
	Signals.connect("show_notes", self.toggle_self)
	
func toggle_self():
	if self.visible:
		self.visible = false
	else:
		self.visible = true


func _on_close_requested():
	self.visible = false
