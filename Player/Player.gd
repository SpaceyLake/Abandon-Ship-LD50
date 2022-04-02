extends KinematicBody2D

var _input : Vector2 = Vector2.ZERO
var _velocity : Vector2 = Vector2.ZERO
export var _velocity_decrease = 0.9
export var _movement_speed : int = 100
export var _minimum_velocity : float = 0.01

func _ready():
	Global._player = self
	pass

func _physics_process(delta):
	_input = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
						Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	_velocity += _input * delta * _movement_speed
	_velocity *= _velocity_decrease
	if abs(_velocity.x) < _minimum_velocity: _velocity = Vector2(0, _velocity.y)
	if abs(_velocity.y) < _minimum_velocity: _velocity = Vector2(_velocity.x, 0)
	_velocity = move_and_slide(_velocity, Vector2.ZERO, false)
	
	#Animation
	if _input == Vector2.ZERO:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Walk")
		if _input.x != 0:
			$Sprite.flip_h = _input.x < 0

func _exit_tree():
	Global._player = null

func _attacked(_body):
	modulate = Color.green
