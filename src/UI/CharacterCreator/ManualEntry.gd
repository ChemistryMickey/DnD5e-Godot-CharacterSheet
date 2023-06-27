extends HBoxContainer


var stats = ["STR", "DEX", "CON", "INT", "WIL", "CHA"]


func _ready() -> void:
	for stat in stats:
		var new_edit = LineEdit.new()
		new_edit.placeholder_text = stat
		new_edit.size_flags_horizontal = new_edit.SIZE_EXPAND_FILL
		self.add_child(new_edit)

