extends KinematicBody2D

export var _velocity : Vector2 = Vector2.ZERO
var _input : Vector2 = Vector2.ZERO
export var _velocity_decrease : float = 0.85
export var _movement_speed : float = 300
export var _attack_distance : float = 6
export var _minimum_velocity : float = 0.01
export var _health : int = 5
export var _damage : int = 1
export var _knockback = 100
var _known_player_position : Vector2 = Vector2.ZERO
onready var _vision : RayCast2D = $Vision
onready var _attack_area : Area2D = $AttackArea


var _is_attacking : bool = false

func _ready():
	add_to_group("Enemy", true)
	_attack_area.connect("body_entered", Global._player, "_attacked", [_damage, _knockback, position])
	_known_player_position = position

func _physics_process(delta):
	#_vision.transform.
	if Global._player != null and !_is_attacking:
		_vision.look_at(Global._player.transform.origin)
		if _vision.get_collider() == Global._player:
			_known_player_position = _vision.get_collision_point()
			if transform.origin.distance_to(_known_player_position) < _attack_distance:
				_attack_start()
			$Vision/Icon.modulate = Color.green
		else:
			$Vision/Icon.modulate = Color.blue
		if global_position.distance_to(_known_player_position) > 4:
			_input = (_known_player_position - global_position).normalized()
		else:
			_input = Vector2.ZERO
		_velocity += _input * _movement_speed * delta
	
	_velocity *= _velocity_decrease
	if abs(_velocity.x) < _minimum_velocity: _velocity = Vector2(0, _velocity.y)
	if abs(_velocity.y) < _minimum_velocity: _velocity = Vector2(_velocity.x, 0)
	_velocity = move_and_slide(_velocity, Vector2.ZERO, false)
	
	#Animation
	if !_is_attacking:
		if _input == Vector2.ZERO:
			$AnimationPlayer.play("Idle")
		else:
			$AnimationPlayer.play("Walk")
			if _input.x != 0:
				$Sprite.flip_h = _input.x < 0

func _bullet_hit(damage, knockback, bullet_velocity, _bullet_origin):
	_known_player_position = _bullet_origin
	_health -= damage
	_velocity += bullet_velocity * knockback
	print(_velocity)
	if _health <= 0:
		queue_free()
		_attack_area.disconnect("body_entered", Global._player, "_attacked")

func _attack_start():
	_is_attacking = true
	$AnimationPlayer.play("Attack")

func _attack_trigger():
	_attack_area.monitoring = true

func _attack_end_trigger():
	_attack_area.monitoring = false

func _attack_finished():
	_is_attacking = false
