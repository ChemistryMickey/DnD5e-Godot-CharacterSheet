extends Window

func _ready() -> void:
	Signals.connect("show_options", Callable(self, "toggle_self"))

func toggle_self():
	return # Stop displaying this. It's not helpful.
	if self.visible:
		self.visible = false
	else:
		self.visible = true

func _on_QuitToDesktop_button_up() -> void:
	Signals.emit_signal("show_confirmation", "quit_to_desktop")
	self.visible = false

func _on_QuitToMainMenu_button_up() -> void:
	Signals.emit_signal("show_confirmation", "quit_to_main_menu")
	self.visible = false


func _on_close_requested():
	self.visible = false # Replace with function body.
