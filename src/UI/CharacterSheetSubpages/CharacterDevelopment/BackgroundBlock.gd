extends TextEdit

func _ready() -> void:
	Signals.connect("emit_background_string", Callable(self, "update_text"))
	
func update_text(background_text : String):
	self.text = background_text

