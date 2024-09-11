extends HBoxContainer
class_name SkillLine

@onready var skill_label = $Panel/Skill
@onready var stat_label = $Panel2/Stat

@export_enum ("STR", "DEX", "CON", "INT", "WIS", "CHA") var stat
@export_enum ("Acrobatics", "Animal Handling", "Arcana", "Athletics", 
"Deception", "History", "Insight", "Intimidation", "Investigation",
"Medicine", "Nature", "Perception", "Performance", "Persuasion", 
"Religion", "Sleight of Hand", "Stealth", "Survival") var skill

var proficiency_bonus : int = 0

func _ready() -> void:
	skill_label.text = skill
	stat_label.text = stat
	Signals.emit_signal("proficiency_requested")
	if Signals.connect("proficiency_returned", update_proficiency_bonus):
		print("Unable to connect to proficiency_returned!")
	if Signals.connect("ability_score_changed", update_base_val):
		print("Unable to connect to ability_score_changed!")
		
func update_base_val(stat_in : String, val : float):
	if $Panel2/Stat.text == stat_in:
		$BaseVal.text = str(val)
	update_skill_bonus()
	
func update_proficiency_bonus(proficiency : String):
	proficiency_bonus = int(proficiency)
	update_skill_bonus()
	
func _on_MiscBonus_text_changed(_new_text: String) -> void:
	Signals.emit_signal("proficiency_requested")
	update_skill_bonus()

func _on_Proficient_button_up() -> void:
	Signals.emit_signal("proficiency_requested")
	update_skill_bonus()

func _on_DoubleProficient_button_up() -> void:
	Signals.emit_signal("proficiency_requested")
	update_skill_bonus()

func update_skill_bonus():
	var total_bonus = int($MiscBonus.text) + int($BaseVal.text)
	if $Proficient.button_pressed:
		total_bonus += proficiency_bonus
	if $DoubleProficient.button_pressed:
		total_bonus += proficiency_bonus
	#Debug.debug_print("Skill bonus: %d" % total_bonus)
	$SkillBonus.text = str(total_bonus)
	if $Panel/Skill.text == "Perception":
		Signals.emit_signal("perception_bonus_changed", $SkillBonus.text)

func save():
	var save_dict = {
		"Base" : $BaseVal.text, 
		"Bonus" : $MiscBonus.text, 
		"Proficient" : $Proficient.button_pressed,
		"DoubleProficient" : $DoubleProficient.button_pressed
	}
	return save_dict
	
func load_sheet(save_dict):
	$BaseVal.text = save_dict["Base"]
	$MiscBonus.text = save_dict["Bonus"]
	$Proficient.button_pressed = save_dict["Proficient"]
	$DoubleProficient.button_pressed = save_dict["DoubleProficient"]
	update_skill_bonus()
	Signals.emit_signal("skill_bonus_changed")
