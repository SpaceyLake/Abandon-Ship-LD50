extends Node2D

var _is_open = false

onready var _animation_player = $AnimationPlayer

func get_is_open():
	return _is_open

func set_open_close_time(seconds : float):
	_animation_player.playback_speed(1/seconds)

func open():
	if !_is_open:
		_animation_player.play("OpenClose")
	_is_open = true

func close():
	if _is_open:
		_animation_player.play_backwards("OpenClose")
	_is_open = false
