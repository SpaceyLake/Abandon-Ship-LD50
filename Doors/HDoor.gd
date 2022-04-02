extends Node2D

export var _closing_time : float = 1

var _is_open = false

onready var _animation_player = $AnimationPlayer

func _ready():
	set_open_close_time(_closing_time)

func get_is_open():
	return _is_open

func set_open_close_time(seconds : float):
	_animation_player.set_speed_scale(1/seconds)

func open():
	if !_is_open:
		_animation_player.play("OpenClose")
	_is_open = true

func close():
	if _is_open:
		_animation_player.play_backwards("OpenClose")
	_is_open = false
