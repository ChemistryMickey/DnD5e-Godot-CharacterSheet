extends Node
#warning-ignore-all:unused_signal

# Player/Environment Interactions
signal Button_Hover(text_out)

signal show_notes()
signal show_options()
signal show_item_database()
signal show_confirmation(confirmation_str)

## SceneChanger
signal Scene_Changing()
signal Scene_Changed()

## Character summary
signal class_updated(class_choice)
signal race_changed(race_choice)

signal money_changed()
signal money_updated(money_values)

signal exp_changed()
signal exp_updated(exp_value)

signal prepared_spells_changed(spell_dict)
signal spell_info_requested(spell)
signal add_to_prepared_spells(spell)

signal feat_info_requested(feat)
signal add_feat(feat)
signal feats_updated(feat_list)

signal skill_bonus_changed()
signal perception_bonus_changed(new_perception)
signal proficiency_requested()
signal proficiency_returned(prof_val)

signal ability_score_changed(stat, val)

## Character Development
signal emit_background_string(background_string)
signal stat_spinner_changed()
signal save_character_creator()

## Spellcasting
signal request_ability_bonus(ability_str)
signal returned_ability_bonus(ability_bonus)

## Inventory
signal equip_item(name)
signal unequip_item(name)
signal display_item_info(node_name, item_name, info_text)
signal item_info_changed(node_name, info_text)
signal update_total_weights_and_values()
signal display_item_database_info(string)
signal add_item_to_inventory(selected_item, quantity)
signal add_purchase_entry(selected_item, quantity, price)

# Incrementers
signal inventory_item_count(num_inventory_entries)
signal decrement_inventory_count()
signal increment_inventory_count()
signal get_inventory_count()

## Cheatsheets
signal request_subcheatsheet(sheet_name)
signal cheatsheet_info_requested(sheet_name, subsheet_name)
