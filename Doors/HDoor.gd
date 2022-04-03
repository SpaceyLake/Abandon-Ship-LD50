extends Node2D

signal _sync_map(_opened)

export var _closing_time : float = 1

var _is_open = false

onready var _animation_player = $AnimationPlayer

func _ready():
	add_to_group("HDoors")
	set_open_close_time(_closing_time)

func get_is_open():
	return _is_open

func set_open_close_time(seconds : float):
	_animation_player.set_speed_scale(1/seconds)

func open():
	if !_is_open:
		_animation_player.play("OpenClose")
		emit_signal("_sync_map", true)
	_is_open = true

func close():
	if _is_open:
		_animation_player.play_backwards("OpenClose")
		emit_signal("_sync_map", false)
	_is_open = false
