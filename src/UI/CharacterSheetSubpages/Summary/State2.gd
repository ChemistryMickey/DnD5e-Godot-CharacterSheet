extends HBoxContainer

func save():
	var save_dict = {
		"AC" : $acEdit.text,
		"Bloodied?" : $BloodiedButton.pressed,
		"Life Saves" : [
			$LifeSavingThrows/HBoxContainer/LIFE1.pressed,
			$LifeSavingThrows/HBoxContainer/LIFE2.pressed,
			$LifeSavingThrows/HBoxContainer/LIFE3.pressed
		],
		"Death Saves" : [
			$DeathSavingThrows/HBoxContainer/DEATH1.pressed,
			$DeathSavingThrows/HBoxContainer/DEATH2.pressed,
			$DeathSavingThrows/HBoxContainer/DEATH3.pressed
		],
		"Inspired" : $Inspired.pressed,
		"Encumbered" : $Encumbered.pressed
	}
	return save_dict
	
func load_sheet(save_dict):
	$acEdit.text = save_dict["AC"]
	$BloodiedButton.pressed = save_dict["Bloodied?"]
	$LifeSavingThrows/HBoxContainer/LIFE1.pressed = save_dict["Life Saves"][0]
	$LifeSavingThrows/HBoxContainer/LIFE2.pressed = save_dict["Life Saves"][1]
	$LifeSavingThrows/HBoxContainer/LIFE3.pressed = save_dict["Life Saves"][2]
	$DeathSavingThrows/HBoxContainer/DEATH1.pressed = save_dict["Death Saves"][0]
	$DeathSavingThrows/HBoxContainer/DEATH2.pressed = save_dict["Death Saves"][1]
	$DeathSavingThrows/HBoxContainer/DEATH3.pressed = save_dict["Death Saves"][2]
	$Inspired.pressed = save_dict["Inspired"]
	$Encumbered.pressed = save_dict["Encumbered"]
