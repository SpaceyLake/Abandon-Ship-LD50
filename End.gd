extends Control

export var _wait_time : float = 0.5
onready var _wait_timer : Timer = $WaitTimer
var _ready = false

func _ready():
	_wait_timer.wait_time = _wait_time
	_wait_timer.one_shot = true
	_wait_timer.connect("timeout", self, "_set_ready")
	_wait_timer.start()

func _process(delta):
	if Input.is_action_just_pressed("fire_down") or Input.is_action_just_pressed("fire_left") or Input.is_action_just_pressed("fire_right") or Input.is_action_just_pressed("fire_up") or Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_up") and _ready:
		get_tree().change_scene("res://MainMenu.tscn")

func _set_ready():
	_ready = true
