extends HBoxContainer
class_name StatLine

@export var stat_str = ""

@onready var stat_label = $Panel/Stat
@onready var base_val = $BaseVal
@onready var misc_bonus = $MiscBonus
@onready var total_stat = $TotalStat
@onready var ability_bonus = $AbilityBonus

func _ready() -> void:
	Signals.connect("request_ability_bonus", Callable(self, "emit_ability_bonus"))
	stat_label.text = stat_str
	calculate_total_stat()
	
func emit_ability_bonus(stat_request: String):
	if stat_str == stat_request:
		Signals.emit_signal("returned_ability_bonus", int($AbilityBonus.text))
	
func _on_BaseVal_text_changed(_new_text: String) -> void:
	calculate_total_stat()
	
func _on_MiscBonus_text_changed(_new_text: String) -> void:
	calculate_total_stat()

func calculate_bonus() -> void:
	var bonus = floor((float(total_stat.text) - 10.0) / 2.0)
	ability_bonus.text = str(bonus)
	Signals.emit_signal("ability_score_changed", $Panel/Stat.text, bonus)
	
func calculate_total_stat():
	var total_stat_val = int(base_val.text) + int(misc_bonus.text)
	total_stat.text = str(total_stat_val)
	calculate_bonus()

func save():
	var save_dict = {
		"Base" : $BaseVal.text,
		"Misc Bonus" : $MiscBonus.text,
		"Saving Throw" : $SavingThrow.button_pressed
	}
	return save_dict
	
func load_sheet(save_dict):
	$BaseVal.text = save_dict["Base"]
	$MiscBonus.text = save_dict["Misc Bonus"]
	$SavingThrow.button_pressed = save_dict["Saving Throw"]
	calculate_total_stat()
