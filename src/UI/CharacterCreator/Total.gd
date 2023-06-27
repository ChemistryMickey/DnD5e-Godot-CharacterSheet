extends HBoxContainer

var stats = ["STR", "DEX", "CON", "INT", "WIL", "CHA"]

func _ready() -> void:
	for stat in stats:
		var new_line = LineEdit.new()
		new_line.size_flags_horizontal = new_line.SIZE_EXPAND_FILL
		new_line.placeholder_text = stat
		new_line.add_to_group("Persist")
		self.add_child(new_line)
