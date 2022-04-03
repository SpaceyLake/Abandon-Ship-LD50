extends KinematicBody2D

signal health_changed(health)
signal max_health_changed(max_health)
signal _sync_map(_position)

const _max_health = 10
var _health = 10
var _input : Vector2 = Vector2.ZERO
var _fire_input : Vector2 = Vector2.ZERO
var _velocity : Vector2 = Vector2.ZERO
export var _velocity_decrease = 0.7
export var _movement_speed : int = 300*7
export var _minimum_velocity : float = 0.01
#export(Array, PackedScene) var weapons
export(Array, PackedScene) var _weapons_resources
export var _touch_length : float = 6
onready var _touch : RayCast2D = $Touch
var _weapons : Array = []
var _weapon_index : int = 0
var _interacting_object : Node2D = null
var _direction_x : bool

onready var _sprite_default = preload("res://Sprites/Player/player_walk.png")
onready var _sprite_holding = preload("res://Sprites/Player/player_walk_armless.png")

func _ready():
	Global._player = self
	connect("max_health_changed", Global._UI, "_set_max_health")
	connect("health_changed", Global._UI, "_set_healthbar")
	emit_signal("max_health_changed", _max_health)
	emit_signal("health_changed", _health)
	for n in _weapons_resources.size():
		_weapons.append(Global.instance_node(_weapons_resources[n], $WeaponHoldPoint.global_position, $WeaponHoldPoint))
		if n != _weapon_index:
			_weapons[n].visible = false
	
#	if _current_weapon == null:
#		$Sprite.set_texture(_sprite_default)
#	else:
	$Sprite.set_texture(_sprite_holding)

func _physics_process(delta):
	_input = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
						Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	if _input != Vector2.ZERO:
		if abs(_input.x) > abs(_input.y):
			if (_input.x > 0):
				_touch.cast_to = Vector2.RIGHT * _touch_length
			else:
				_touch.cast_to = Vector2.LEFT * _touch_length
		else:
			if (_input.y < 0):
				_touch.cast_to = Vector2.UP * _touch_length
			else:
				_touch.cast_to = Vector2.DOWN * _touch_length
	
	if Input.is_action_just_pressed("interact"):
		if _touch.get_collider() != null:
			_touch.get_collider()._interact()
			_interacting_object = _touch.get_collider()
	
	if _interacting_object != null:
		if Input.is_action_just_released("interact") or _touch.get_collider() != _interacting_object:
			_interacting_object._stop_interaction()
			_interacting_object = null
	
	_velocity += _input * delta * _movement_speed
#	if _input == Vector2.ZERO:
#		_velocity = Vector2.ZERO
	_velocity *= _velocity_decrease
	if abs(_velocity.x) < _minimum_velocity: _velocity = Vector2(0, _velocity.y)
	if abs(_velocity.y) < _minimum_velocity: _velocity = Vector2(_velocity.x, 0)
	_velocity = move_and_slide(_velocity, Vector2.ZERO, false)
	emit_signal("_sync_map", global_position)
	_fire_input = Vector2.ZERO
	if Input.is_action_pressed("fire_up"): _fire_input = Vector2.UP
	if Input.is_action_pressed("fire_down"): _fire_input = Vector2.DOWN
	if Input.is_action_pressed("fire_left"): _fire_input = Vector2.LEFT
	if Input.is_action_pressed("fire_right"): _fire_input = Vector2.RIGHT
	
	#Animation
	if _input == Vector2.ZERO:
		$AnimationPlayer.play("Idle")
		_weapons[_weapon_index]._set_animation(true, Vector2(_fire_input.x +_input.x*0.5, _fire_input.y))
	else:
		$AnimationPlayer.play("Walk")
		_weapons[_weapon_index]._set_animation(false, Vector2(_fire_input.x +_input.x*0.5, _fire_input.y))
		
	if _fire_input.x != 0:
		$Sprite.flip_h = _fire_input.x < 0
		$WeaponHoldPoint.position.x = 3 * -sign(_fire_input.x)
		_weapons[_weapon_index]._set_right(_fire_input.x > 0)
	elif _input.x != 0:
		
		$Sprite.flip_h = _input.x < 0
		$WeaponHoldPoint.position.x = 3 * -sign(_input.x)
		_weapons[_weapon_index]._set_right(_input.x > 0)
	
	if _fire_input != Vector2.ZERO:
		_weapons[_weapon_index]._fire(_fire_input)

func _exit_tree():
	Global._player = null

func _attacked(damage, _knockback):
	_velocity += _knockback
	_health -= damage
	emit_signal("health_changed", _health)
	if _health <= 0: get_tree().change_scene("res://EndLose.tscn")

func _swap_weapon():
	_weapons[_weapon_index].visible = false
	if _weapon_index < _weapons.size() - 1:
		_weapon_index += 1
	else:
		_weapon_index = 0
	_weapons[_weapon_index]._set_right(!$Sprite.flip_h)
	_weapons[_weapon_index].visible = true

func _heal():
	if _health < _max_health:
		_health += 1
	emit_signal("health_changed", _health)
