extends VBoxContainer

export var ability_bonus : int = 0
export var proficiency_bonus : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var select_menu : OptionButton = $SpellcastingAbility/SpellcastingAbilitySelection
	var spellcasting_mod = select_menu.selected
	Signals.emit_signal("request_ability_bonus", select_menu.get_item_text(spellcasting_mod))
	Signals.connect("returned_ability_bonus", self, "update_ability_bonus")
	Signals.connect("proficiency_returned", self, "update_proficiency_bonus")
	
func update_proficiency_bonus(val):
	proficiency_bonus = int(val)
	update_spell_attributes()
	
func update_ability_bonus(val):
	ability_bonus = int(val)
	update_spell_attributes()
	
func update_spell_attributes():
	$SpellSaveDC/LineEdit.text = String(8 + ability_bonus + proficiency_bonus)
	$SpellAttackBonus/LineEdit.text = String(ability_bonus + proficiency_bonus)

func _on_SpellcastingAbilitySelection_item_selected(index: int) -> void:
	var select_menu : OptionButton = $SpellcastingAbility/SpellcastingAbilitySelection
	Signals.emit_signal("request_ability_bonus", select_menu.get_item_text(index))
