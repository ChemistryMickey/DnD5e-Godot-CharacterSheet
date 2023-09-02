extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var black = $Control/Black

func change_scene_to_file( path, delay = 0.5, _player_position = Vector2.ZERO ):
	Signals.emit_signal("Scene_Changing")
	await get_tree().create_timer(delay).timeout
	animation_player.play("fade")
	await animation_player.animation_finished
	assert( get_tree().change_scene_to_file(path) == OK )
	
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	Signals.emit_signal("Scene_Changed")
