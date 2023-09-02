extends HBoxContainer

var stats = ["STR", "DEX", "CON", "INT", "WIL", "CHA"]
func _ready() -> void:
	for stat in stats:
		var new_incr = SpinBox.new()
		new_incr.size_flags_horizontal = new_incr.SIZE_EXPAND_FILL
		new_incr.prefix = stat
		new_incr.value = 8 #default
		new_incr.min_value = 8
		new_incr.max_value = 15
		new_incr.set_script(load("res://src/UI/CharacterCreator/StatSpinner.gd"))
		self.add_child(new_incr)
		
	Signals.connect("stat_spinner_changed", Callable(self, "update_total_points"))
	
func update_total_points():
	var val_map = {0 : -9, 1 : -7, 2 : -6, 3: -5, 4: -4, 5: -3, 6: -2, 7: -1, 8 : 0,
					9 : 1, 10 : 2, 11 : 3, 12 : 4, 13 : 5, 14 : 7, 15 : 9}
	var default_val = 27
	for child in self.get_children():
		if child is StatSpinner:
			default_val -= val_map[int(child.val)]
	$TotalPoints.text = String(default_val)
