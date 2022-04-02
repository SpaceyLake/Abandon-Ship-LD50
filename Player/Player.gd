extends KinematicBody2D

signal health_changed(health)
signal max_health_changed(max_health)

const _max_health = 10
var _health = 10
var _input : Vector2 = Vector2.ZERO
var _fire_input : Vector2 = Vector2.ZERO
var _velocity : Vector2 = Vector2.ZERO
export var _velocity_decrease = 0.85
export var _movement_speed : int = 300
export var _minimum_velocity : float = 0.01
#export(Array, PackedScene) var weapons
export var weapon : PackedScene
onready var _current_weapon = null

onready var _sprite_default = preload("res://Sprites/Player/player_walk.png")
onready var _sprite_holding = preload("res://Sprites/Player/player_walk_armless.png")

func _ready():
	Global._player = self
	connect("max_health_changed", Global._UI, "_update_max_health")
	connect("health_changed", Global._UI, "_update_healthbar")
	emit_signal("max_health_changed", _max_health)
	emit_signal("health_changed", _health)
	_current_weapon = Global.instance_node(weapon, $WeaponHoldPoint.global_position, $WeaponHoldPoint)
	
	if _current_weapon == null:
		$Sprite.set_texture(_sprite_default)
	else:
		$Sprite.set_texture(_sprite_holding)

func _physics_process(delta):
	_input = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
						Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	_velocity += _input * delta * _movement_speed
	_velocity *= _velocity_decrease
	if abs(_velocity.x) < _minimum_velocity: _velocity = Vector2(0, _velocity.y)
	if abs(_velocity.y) < _minimum_velocity: _velocity = Vector2(_velocity.x, 0)
	_velocity = move_and_slide(_velocity, Vector2.ZERO, false)
	
	_fire_input = Vector2.ZERO
	if Input.is_action_pressed("fire_up"):
		_fire_input = Vector2.UP
		_current_weapon._fire(_fire_input)
	if Input.is_action_pressed("fire_down"):
		_fire_input = Vector2.DOWN
		_current_weapon._fire(_fire_input)
	if Input.is_action_pressed("fire_left"):
		_fire_input = Vector2.LEFT
		_current_weapon._fire(_fire_input)
	if Input.is_action_pressed("fire_right"):
		_fire_input = Vector2.RIGHT
		_current_weapon._fire(_fire_input)
	
	#Animation
	if _input == Vector2.ZERO:
		$AnimationPlayer.play("Idle")
		_current_weapon._set_animation(true, Vector2(_fire_input.x +_input.x*0.5, _fire_input.y))
	else:
		$AnimationPlayer.play("Walk")
		_current_weapon._set_animation(false, Vector2(_fire_input.x +_input.x*0.5, _fire_input.y))
		
	if _fire_input.x != 0:
		$Sprite.flip_h = _fire_input.x < 0
		$WeaponHoldPoint.position.x = 2.5 * -sign(_fire_input.x)
		_current_weapon._set_right(_fire_input.x > 0)
	elif _input.x != 0:
		$Sprite.flip_h = _input.x < 0
		$WeaponHoldPoint.position.x = 2.5 * -sign(_input.x)
		_current_weapon._set_right(_input.x > 0)

func _exit_tree():
	Global._player = null

func _attacked(_body, damage):
	_health -= damage
	emit_signal("health_changed", _health)
	if _health <= 0: get_tree().reload_current_scene()
