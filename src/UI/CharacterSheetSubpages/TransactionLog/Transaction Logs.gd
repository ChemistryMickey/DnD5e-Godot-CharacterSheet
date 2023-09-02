extends HBoxContainer

var experience_log_template = preload("res://src/UI/CharacterSheetSubpages/TransactionLog/ExperienceEntry.tscn")
var money_log_template = preload("res://src/UI/CharacterSheetSubpages/TransactionLog/MoneyEntry.tscn")

@onready var experience_log = $Left/ExperienceLog/ExperienceEntries
@onready var experience_total = $Left/Total/ExpAmountEdit

@onready var money_log = $Right/MoneyLog/MoneyEntries
@onready var money_totals = [$Right/Total/cpEdit, $Right/Total/spEdit, $Right/Total/epEdit, 
							$Right/Total/gpEdit, $Right/Total/ppEdit]

func _ready() -> void:
	if Signals.connect("money_changed", Callable(self, "update_money_total")): print("Unable to connect to money_changed!")
	if Signals.connect("exp_changed", Callable(self, "update_exp_total")): print("Unable to connect to exp_changed!")

func _on_Exp_AddEntry_button_up() -> void:
	var new_exp_entry = experience_log_template.instantiate()
	var exp_log_timestamp = new_exp_entry.get_child(0)
	exp_log_timestamp.text = Time.get_date_string_from_system()
	
	experience_log.add_child(new_exp_entry)
	Signals.emit_signal("exp_changed")

func _on_Money_AddEntry_button_up() -> void:
	var new_money_entry = money_log_template.instantiate()
	var money_log_timestamp = new_money_entry.get_child(0)
	money_log_timestamp.text = Time.get_date_string_from_system()
	
	money_log.add_child(new_money_entry)

func _on_Exp_RemoveLastEntry_button_up() -> void:
	if experience_log.get_child_count() > 0:
		experience_log.get_child(experience_log.get_child_count() - 1).queue_free()
		Signals.emit_signal("exp_changed")

func _on_Money_RemoveLastEntry_button_up() -> void:
	if money_log.get_child_count() > 0:
		money_log.get_child(money_log.get_child_count() - 1).queue_free()
		Signals.emit_signal("money_changed")

func update_money_total():
	var total_copper = 0
	var cur_money_totals = [0, 0, 0, 0, 0]
	var money_multiples = [1, 10, 50, 100, 1000]
	var money_index = 0
	var money_entries = money_log.get_children()
	for entry in money_entries:
		var entry_children = entry.get_children()
		for child in entry_children:
			if child is ReadableLineEdit:
				if child.text.count('-') > 0:
					total_copper -= int(child.text.split('-')[1]) * money_multiples[money_index]
				else:
					total_copper += int(child.text) * money_multiples[money_index]
				money_index += 1
				#Debug.debug_print("Total Copper %d" % total_copper)
		money_index = 0
	
	for currency in range(money_multiples.size() - 1, 0, -1):
		cur_money_totals[currency] = total_copper / money_multiples[currency]
		total_copper -= cur_money_totals[currency] * money_multiples[currency]
	cur_money_totals[0] = total_copper
	for idx in range(money_totals.size()):
		money_totals[idx].text = str(cur_money_totals[idx])
	Signals.emit_signal("money_updated", cur_money_totals)
	
func update_exp_total():
	var exp_total = 0
	var experience_entries = experience_log.get_children()
	for entry in experience_entries:
		var entry_children = entry.get_children()
		for child in entry_children:
			if child is ReadableLineEdit:
				exp_total += int(child.text)
	experience_total.text = str(exp_total)
	Signals.emit_signal("exp_updated", exp_total)
