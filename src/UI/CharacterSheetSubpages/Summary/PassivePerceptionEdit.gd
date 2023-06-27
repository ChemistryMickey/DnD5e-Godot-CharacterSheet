extends LineEdit

func _ready() -> void:
	Signals.connect("perception_bonus_changed", self, "update_passive_perception")
	
func update_passive_perception(new_passive):
	self.text = String(int(new_passive) + 10)
