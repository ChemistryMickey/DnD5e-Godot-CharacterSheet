extends ScrollContainer

# Preloaded Bits
## None

# Buttons
onready var bloodied_button = $Summary/Right/State2/BloodiedButton

# Line Edits
onready var max_hp_edit = $Summary/Right/State/maxHPEdit
onready var proficiency_edit = $Summary/Right/State/ProficiencyEdit
onready var money_edits = [	$Summary/Right/MoneyAndExp/cpDisp, 
							$Summary/Right/MoneyAndExp/spDisp, 
							$Summary/Right/MoneyAndExp/epDisp, 
							$Summary/Right/MoneyAndExp/gpDisp, 
							$Summary/Right/MoneyAndExp/ppDisp]
onready var exp_edit = $Summary/Right/MoneyAndExp/expDisp
onready var char_name = $Summary/Left/CharacterInfo/CharacterChoices/NameEnter

# Containers
onready var language_container = $Summary/Left/TabSummaries/LanguagesAndTools/ScrollBox/LanguageContainer
onready var tool_container = $Summary/Left/TabSummaries/LanguagesAndTools/ScrollBox2/ToolContainer
onready var prepared_spells_container = $Summary/Left/TabSummaries/SpellsAndFeats/VBoxContainer/PreparedSpells
onready var skill_block = $Summary/Right/Skills/SkillBlock

func _ready():
	if Signals.connect("exp_updated", self, "update_exp_label"): 
		print("Unable to connect to exp_updated!")
	if Signals.connect("money_updated", self, "update_money_labels"): 
		print("Unable to connect to money_updated!")
	if Signals.connect("prepared_spells_changed", self, "update_prepared_list"): 
		print("Unable to connecto to prepared_spells_changed!")
	if Signals.connect("proficiency_requested", self, "emit_proficiency_bonus"):
		print("Unable to connect to proficiency_requested!")
		
func emit_proficiency_bonus():
	Signals.emit_signal("proficiency_returned", $Summary/Right/State/ProficiencyEdit.text)

func _on_ClassChoice_class_updated(new_class : String) -> void:
	Signals.emit_signal("class_updated", new_class)

func _on_hpEdit_text_entered(new_text: String) -> void:
	var cur_health = int(new_text)
	Debug.debug_print("New health: %d" % cur_health)
	if cur_health < floor(0.5 * int(max_hp_edit.text)):
		Debug.debug_print("Player bloodied!")
		bloodied_button.pressed = true
	else:
		bloodied_button.pressed = false
		
func _on_LevelEdit_text_changed(new_text: String) -> void:
	update_proficiency_bonus(new_text)

func update_proficiency_bonus(new_bonus : String):
	var cur_level = int(new_bonus)
	proficiency_edit.text = String(floor(cur_level/4) + 2)
	Signals.emit_signal("proficiency_returned", proficiency_edit.text)
	
func update_exp_label(exp_amount):
	exp_edit.text = String(exp_amount)

func update_money_labels(money_amounts : Array):
	for idx in range(money_amounts.size()):
		money_edits[idx].text = String(money_amounts[idx])

func update_prepared_list(spell_dict : Dictionary):
	prepared_spells_container.clear()
	for spell_level in spell_dict:
		prepared_spells_container.add_item("---------- %s" % spell_level, null, false)
		for spell in spell_dict[spell_level]:
			var ind = prepared_spells_container.get_item_count()
			var tool_tip_text = DatabaseLoader.parse_list(DatabaseLoader.json_dicts["spellcasting"]["Spell Descriptions"][spell]["content"])
			prepared_spells_container.add_item(spell)
			prepared_spells_container.set_item_tooltip(ind, tool_tip_text)

func save():
	var save_dict = {
		"Name" : $Summary/Left/CharacterInfo/CharacterChoices/NameEnter.text,
		"Class" : $Summary/Left/CharacterInfo/CharacterChoices/ClassChoice.text,
		"Race" : $Summary/Left/CharacterInfo/CharacterChoices/RaceChoice.text,
		"Height" : $Summary/Left/CharacterInfo/CharacterChoices/HeightEnter.text,
		"Hair Color" : $Summary/Left/CharacterInfo/CharacterChoices/HairEnter.text,
		"Eye Color" : $Summary/Left/CharacterInfo/CharacterChoices/EyeEnter.text,
		"Age" : $Summary/Left/CharacterInfo/CharacterChoices/AgeEnter.text,
		"Level" : $Summary/Left/CharacterInfo/CharacterChoices/LevelEdit.text,
		"Sex" : $Summary/Left/CharacterInfo/CharacterChoices/SexEdit.text,
		"Weight" : $Summary/Left/CharacterInfo/CharacterChoices/WeightEdit.text
	}
	return save_dict

func load_sheet(save_dict):
	$Summary/Left/CharacterInfo/CharacterChoices/NameEnter.text = save_dict["Name"]
	$Summary/Left/CharacterInfo/CharacterChoices/ClassChoice.text = save_dict["Class"]
	$Summary/Left/CharacterInfo/CharacterChoices/RaceChoice.text = save_dict["Race"]
	$Summary/Left/CharacterInfo/CharacterChoices/HeightEnter.text = save_dict["Height"]
	$Summary/Left/CharacterInfo/CharacterChoices/HairEnter.text = save_dict["Hair Color"]
	$Summary/Left/CharacterInfo/CharacterChoices/EyeEnter.text = save_dict["Eye Color"]
	$Summary/Left/CharacterInfo/CharacterChoices/AgeEnter.text = save_dict["Age"]
	$Summary/Left/CharacterInfo/CharacterChoices/LevelEdit.text = save_dict["Level"]
	$Summary/Left/CharacterInfo/CharacterChoices/SexEdit.text = save_dict["Sex"]
	$Summary/Left/CharacterInfo/CharacterChoices/WeightEdit.text = save_dict["Weight"]
	
	$Summary/Left/TabSummaries/Equipment/ItemList/ItemList.clear()
	update_proficiency_bonus($Summary/Left/CharacterInfo/CharacterChoices/LevelEdit.text)
