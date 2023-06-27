extends HBoxContainer

func save():
	var save_dict = {
		"Walk Speed" : $WalkEnter.text,
		"Climb Speed" : $ClimbEnter.text,
		"Swim Speed" : $SwimEnter.text,
		"Fly Speed" : $FlyEnter.text
	}
	return save_dict
	
func load_sheet(save_dict):
	$WalkEnter.text = save_dict["Walk Speed"]
	$ClimbEnter.text = save_dict["Climb Speed"]
	$SwimEnter.text = save_dict["Swim Speed"]
	$FlyEnter.text = save_dict["Fly Speed"]

