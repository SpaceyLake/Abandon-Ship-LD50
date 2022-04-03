extends Control

onready var _animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	_animation_player.play("Close")

func _set_open(open):
	if open: _animation_player.play("Open")
	else: _animation_player.play("Close")
