extends LineEdit

func _ready() -> void:
	Signals.connect("perception_bonus_changed", Callable(self, "update_passive_perception"))
	
func update_passive_perception(new_passive):
	self.text = str(int(new_passive) + 10)
