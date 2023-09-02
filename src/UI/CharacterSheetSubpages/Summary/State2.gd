extends HBoxContainer

func save():
	var save_dict = {
		"AC" : $acEdit.text,
		"Bloodied?" : $BloodiedButton.button_pressed,
		"Life Saves" : [
			$LifeSavingThrows/HBoxContainer/LifeButtons/LIFE1.button_pressed,
			$LifeSavingThrows/HBoxContainer/LifeButtons/LIFE2.button_pressed,
			$LifeSavingThrows/HBoxContainer/LifeButtons/LIFE3.button_pressed
		],
		"Death Saves" : [
			$DeathSavingThrows/HBoxContainer/DeathButtons/DEATH1.button_pressed,
			$DeathSavingThrows/HBoxContainer/DeathButtons/DEATH2.button_pressed,
			$DeathSavingThrows/HBoxContainer/DeathButtons/DEATH3.button_pressed
		],
		"Inspired" : $Inspired.button_pressed,
		"Encumbered" : $Encumbered.button_pressed
	}
	return save_dict
	
func load_sheet(save_dict):
	$acEdit.text = save_dict["AC"]
	$BloodiedButton.button_pressed = save_dict["Bloodied?"]
	$LifeSavingThrows/HBoxContainer/LifeButtons/LIFE1.button_pressed = save_dict["Life Saves"][0]
	$LifeSavingThrows/HBoxContainer/LifeButtons/LIFE2.button_pressed = save_dict["Life Saves"][1]
	$LifeSavingThrows/HBoxContainer/LifeButtons/LIFE3.button_pressed = save_dict["Life Saves"][2]
	$DeathSavingThrows/HBoxContainer/DeathButtons/DEATH1.button_pressed = save_dict["Death Saves"][0]
	$DeathSavingThrows/HBoxContainer/DeathButtons/DEATH2.button_pressed = save_dict["Death Saves"][1]
	$DeathSavingThrows/HBoxContainer/DeathButtons/DEATH3.button_pressed = save_dict["Death Saves"][2]
	$Inspired.button_pressed = save_dict["Inspired"]
	$Encumbered.button_pressed = save_dict["Encumbered"]
