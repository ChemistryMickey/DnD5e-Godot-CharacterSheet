extends SpinBox
class_name StatSpinner

export (String) var stat_name = ""
export (int) var val = 8

func _ready() -> void:
	self.connect("value_changed", self, "emit_change")
	self.value = val
	
func emit_change(value : float):
	val = int(value)
	Signals.emit_signal("stat_spinner_changed")
