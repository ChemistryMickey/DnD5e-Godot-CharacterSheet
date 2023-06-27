extends HBoxContainer

var stats = ["STR", "DEX", "CON", "INT", "WIL", "CHA"]

func _on_Roll_button_up() -> void:
	var rolls = []
	for stat in stats:
		var min_val = 7
		var local_sum = 0
		for _roll in range(4):
			var roll_val = randi() % 6 + 1
			local_sum += roll_val
			if roll_val < min_val:
				min_val = roll_val
		rolls.append( local_sum - min_val )
	$Rolls.text = ', '.join(rolls)
