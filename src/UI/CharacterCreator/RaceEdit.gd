extends TextEdit

func _ready() -> void:
	Signals.connect("race_changed", self, "update_race_text")
	
func update_race_text(race_choice : String):
	var new_text = DatabaseLoader.stringify_race(DatabaseLoader.json_dicts["races"][race_choice])

	self.text = new_text
