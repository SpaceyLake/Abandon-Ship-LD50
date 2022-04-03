extends KinematicBody2D

signal _enemy_killed()

export var _velocity : Vector2 = Vector2.ZERO
var _input : Vector2 = Vector2.ZERO
export var _velocity_decrease : float = 0.85
export var _movement_speed : float = 300
export var _attack_distance : float = 6
export var _minimum_velocity : float = 0.01
export var _health : int = 5
export var _damage : int = 1
export var _knockback = 100 * 3
var _target_position : Vector2 = Vector2.ZERO
onready var _vision : RayCast2D = $Vision
onready var _attack_area : Area2D = $AttackArea
onready var _influence_area : Area2D = $InfluenceArea
onready var _roam_timer: Timer = $RoamTimer
var _rng = RandomNumberGenerator.new()
export var min_roam_time : float = 4
export var max_roam_time : float = 10
export var max_roam_distance : float = 30

var _is_attacking : bool = false

func _ready():
	_rng.randomize()
	add_to_group("Enemy", true)
	_attack_area.connect("body_entered", self, "_attacking")
	_target_position = global_position
	_roam_timer.connect("timeout", self, "_roam")

func _set_target_position(target_position):
	_target_position = target_position

func _physics_process(delta):
	#_vision.transform.
	if Global._player != null and !_is_attacking:
		_vision.look_at(Global._player.transform.origin)
		if _vision.get_collider() == Global._player:
			_target_position = _vision.get_collision_point()
			if transform.origin.distance_to(_target_position) < _attack_distance:
				_attack_start()
			$Vision/Icon.modulate = Color.green
			_roam_timer.stop()
		else:
			if _roam_timer.is_stopped():
				_roam_timer.wait_time = _rng.randf_range(min_roam_time, max_roam_time)
				_roam_timer.start()
			$Vision/Icon.modulate = Color.blue
		if global_position.distance_to(_target_position) > 4:
			_input = (_target_position - global_position).normalized()
		else:
			_input = Vector2.ZERO
		_velocity += _input * _movement_speed * delta
	
	_velocity *= _velocity_decrease
	if abs(_velocity.x) < _minimum_velocity: _velocity = Vector2(0, _velocity.y)
	if abs(_velocity.y) < _minimum_velocity: _velocity = Vector2(_velocity.x, 0)
	_velocity = move_and_slide(_velocity, Vector2.ZERO, false)
	if _velocity.abs() < Vector2(0.1, 0.1):
		_roam()
	
	#Animation
	if !_is_attacking:
		if _input == Vector2.ZERO:
			$AnimationPlayer.play("Idle")
		else:
			$AnimationPlayer.play("Walk")
			if _input.x != 0:
				$Sprite.flip_h = _input.x < 0

func _bullet_hit(damage, knockback, bullet_velocity, bullet_origin):
	_target_position = bullet_origin
	_influence()
	_health -= damage
	_velocity += bullet_velocity * knockback
	_roam_timer.wait_time = _rng.randf_range(min_roam_time, max_roam_time)
	_roam_timer.start()
	if _health <= 0:
		emit_signal("_enemy_killed")
		queue_free()

func _foam_hit(_repair, knockback, bullet_velocity, bullet_origin):
	_target_position = bullet_origin
	_velocity += bullet_velocity * knockback
	_roam_timer.wait_time = _rng.randf_range(min_roam_time, max_roam_time)
	_roam_timer.start()

func _influence():
	var bodies = _influence_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body._set_target_position(_target_position)

func _attack_start():
	_is_attacking = true
	$AnimationPlayer.play("Attack")

func _attack_trigger():
	_attack_area.monitoring = true

func _attack_end_trigger():
	_attack_area.monitoring = false

func _attack_finished():
	_is_attacking = false

func _attacking(_body):
	Global._player._attacked(_damage, _knockback * (Global._player.global_position - global_position).normalized());

func _roam():
	_roam_timer.wait_time = _rng.randf_range(min_roam_time, max_roam_time)
	_target_position = Vector2(global_position + Vector2(_rng.randf_range(-max_roam_distance, max_roam_distance), _rng.randf_range(-max_roam_distance, max_roam_distance)))
