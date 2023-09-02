@tool
extends Control

@onready var animation_player = $AnimationPlayer

@export var next_scene_path = "" # (String, FILE)
@export (String) var button_help = ""
@export (bool) var use_scene_changer = false

func _get_configuration_warnings() -> String:
	return "Next scene path must be set!" if next_scene_path == "" else ""
	
func _on_ChangeSceneButton_mouse_entered() -> void:
	Signals.emit_signal("Button_Hover", button_help)
	animation_player.play("selected")

func _on_ChangeSceneButton_mouse_exited() -> void:
	Signals.emit_signal("Button_Hover", "")
	animation_player.play("RESET")

func _on_ChangeSceneButton_button_up() -> void:
	if use_scene_changer:
		SceneChanger.change_scene_to_file(next_scene_path, 0)
	else:
		assert(get_tree().change_scene_to_file(next_scene_path) == OK)
	Signals.emit_signal("open_load_dialogue")
