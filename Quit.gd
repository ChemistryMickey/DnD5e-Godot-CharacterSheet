@tool
extends Control

@onready var animation_player = $AnimationPlayer

@export var next_scene_path = "" # (String, FILE)
@export (String) var button_help = ""
@export (bool) var use_scene_changer = false

func _on_ChangeSceneButton_mouse_entered() -> void:
	Signals.emit_signal("Button_Hover", button_help)
	animation_player.play("selected")

func _on_ChangeSceneButton_mouse_exited() -> void:
	Signals.emit_signal("Button_Hover", "")
	animation_player.play("RESET")

func _on_Quit_button_up() -> void:
	get_tree().quit()
