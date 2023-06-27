extends ConfirmationDialog

var conf_dict := {
	"quit_to_desktop" : "Quit to Desktop? (discards unsaved changes)",
	"quit_to_main_menu" : "Quit to Main Menu? (discards unsaved changes)",
	"new_character" : "Create New Character? (discards unsaved changes)"
}
var cur_conf : String = "quit_to_desktop" #Default configuration

func _ready() -> void:
	Signals.connect("show_confirmation", self, "show_confirmation")
	
func show_confirmation(conf_str : String):
	self.show()
	if conf_dict.has(conf_str):
		cur_conf = conf_str
		self.dialog_text = conf_dict[conf_str]

func _on_ConfirmationDialog_confirmed() -> void:
	if cur_conf == "quit_to_desktop":
		get_tree().quit()
	elif cur_conf == "quit_to_main_menu":
		SceneChanger.change_scene("res://MainSplash.tscn", 0)
	elif cur_conf == "new_character":
		SceneChanger.change_scene("res://src/UI/CharacterCreator/CharacterCreator.tscn", 0)
