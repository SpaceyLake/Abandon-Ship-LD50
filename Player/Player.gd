extends KinematicBody2D

signal health_changed(health)
signal max_health_changed(max_health)

const _max_health = 10
var _health = 10
var _input : Vector2 = Vector2.ZERO
var _velocity : Vector2 = Vector2.ZERO
export var _velocity_decrease = 0.85
export var _movement_speed : int = 300
export var _minimum_velocity : float = 0.01
#export(Array, PackedScene) var weapons
export var weapon : PackedScene
onready var _current_weapon

func _ready():
	Global._player = self
	connect("max_health_changed", Global._UI, "_update_max_health")
	connect("health_changed", Global._UI, "_update_healthbar")
	emit_signal("max_health_changed", _max_health)
	emit_signal("health_changed", _health)
	_current_weapon = Global.instance_node(weapon, $WeaponHoldPoint.global_position, self)
	pass

func _physics_process(delta):
	_input = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
						Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	_velocity += _input * delta * _movement_speed
	_velocity *= _velocity_decrease
	if abs(_velocity.x) < _minimum_velocity: _velocity = Vector2(0, _velocity.y)
	if abs(_velocity.y) < _minimum_velocity: _velocity = Vector2(_velocity.x, 0)
	_velocity = move_and_slide(_velocity, Vector2.ZERO, false)
	
	if Input.is_action_just_pressed("fire_up"): _current_weapon._fire(Vector2.UP)
	if Input.is_action_just_pressed("fire_down"): _current_weapon._fire(Vector2.DOWN)
	if Input.is_action_just_pressed("fire_left"): _current_weapon._fire(Vector2.LEFT)
	if Input.is_action_just_pressed("fire_right"): _current_weapon._fire(Vector2.RIGHT)
	
	#Animation
	if _input == Vector2.ZERO:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Walk")
		if _input.x != 0:
			$Sprite.flip_h = _input.x < 0

func _exit_tree():
	Global._player = null

func _attacked(_body, damage):
	_health -= damage
	emit_signal("health_changed", _health)
	if _health <= 0: get_tree().reload_current_scene()
