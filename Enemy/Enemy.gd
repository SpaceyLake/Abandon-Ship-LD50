extends KinematicBody2D

export var _velocity : Vector2 = Vector2.ZERO
export var _velocity_decrease : float = 0.85
export var _movement_speed : float = 1000
export var _attack_distance : float = 18
export var _minimum_velocity : float = 0.01

onready var _vision : RayCast2D = $Vision
onready var _attack_area : Area2D = $Vision/AttackArea

func _ready():
	_attack_area.connect("body_entered", Global._player, "_attacked")

func _physics_process(delta):
	#_vision.transform.
	if Global._player != null:
		_vision.look_at(Global._player.transform.origin)
		if _vision.get_collider() == Global._player:
			_velocity = (Global._player.transform.origin - transform.origin).normalized() * _movement_speed * delta
			if transform.origin.distance_to(_vision.get_collision_point()) < _attack_distance:
				_attack_area.monitoring = true
			$Vision/Icon.modulate = Color.green
		else:
			$Vision/Icon.modulate = Color.blue
	_velocity *= _velocity_decrease
	if abs(_velocity.x) < _minimum_velocity: _velocity = Vector2(0, _velocity.y)
	if abs(_velocity.y) < _minimum_velocity: _velocity = Vector2(_velocity.x, 0)
	_velocity = move_and_slide(_velocity, Vector2.ZERO, false)
