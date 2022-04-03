extends Area2D

var _velocity : Vector2 = Vector2.ZERO
var _direction : Vector2 = Vector2.ZERO
export var _speed : float = 100
export var _speed_decay : float = 100
export var _knockback : float = 100
export var _repair_rate : float = 1
var _spawn_position : Vector2 = Vector2.ZERO

func _ready():
	connect("body_entered", self, "_collide")

func _fire(direction : Vector2):
	_velocity = direction * _speed
	_direction = direction
	_spawn_position = global_position
	global_rotation = _direction.angle()

func _physics_process(delta):
	position += _velocity * delta
	_velocity -= _velocity.normalized() * _speed_decay * delta
	if _velocity.length_squared() < 1:
		queue_free()

func _collide(body):
	if body.is_in_group("Enemy"):
		body._foam_hit(_repair_rate, _knockback, _direction, _spawn_position)
	queue_free()
