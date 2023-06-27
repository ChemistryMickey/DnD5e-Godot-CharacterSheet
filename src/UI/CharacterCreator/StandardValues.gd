extends HBoxContainer

var stats = ["STR", "DEX", "CON", "INT", "WIL", "CHA"]
var std_vals = [15, 14, 13, 12, 10, 8]
func _ready() -> void:
	for stat in stats:
		var new_edit = OptionButton.new()
		for val in std_vals:
			new_edit.add_item(String(val))
		new_edit.text = stat
		new_edit.size_flags_horizontal = new_edit.SIZE_EXPAND_FILL
		self.add_child(new_edit)
