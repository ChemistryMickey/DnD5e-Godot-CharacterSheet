extends CanvasLayer

onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func change_scene( path, delay = 0.5, _player_position = Vector2.ZERO ):
	Signals.emit_signal("Scene_Changing")
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert( get_tree().change_scene(path) == OK )
	
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")
	Signals.emit_signal("Scene_Changed")
