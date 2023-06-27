extends WindowDialog

func _ready() -> void:
	Signals.connect("show_options", self, "toggle_self")

func toggle_self():
	if self.is_visible_in_tree():
		self.hide()
	else:
		self.show()

func _on_QuitToDesktop_button_up() -> void:
	Signals.emit_signal("show_confirmation", "quit_to_desktop")
	self.hide()

func _on_QuitToMainMenu_button_up() -> void:
	Signals.emit_signal("show_confirmation", "quit_to_main_menu")
	self.hide()
