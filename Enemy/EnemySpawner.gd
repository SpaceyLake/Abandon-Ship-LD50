extends StaticBody2D

export var _enemy : PackedScene
export var _spawn_time : float = 2
export var _hull_damage_time : float = 3
export var _time_offset : float = 1
export var _health : int = 5
export var _minimum_target : Vector2 = Vector2.ONE * 16
export var _target_offset : Vector2 = Vector2.ONE * 16
export var _max_spawned : int = 8
export var _hullbreach : PackedScene
var _enemies_spawned : int = 0
onready var _spawn_timer : Timer = $SpawnTimer
onready var _hull_damage_timer : Timer = $HullDamageTimer
onready var _influence_area : Area2D = $InfluenceArea
var _rng = RandomNumberGenerator.new()
var _spawner = null

func _ready():
	add_to_group("Enemy", true)
	_spawn_timer.connect("timeout", self, "_spawn")
	_hull_damage_timer.wait_time = _hull_damage_time
	_hull_damage_timer.one_shot = false
	_hull_damage_timer.autostart = true
	_hull_damage_timer.connect("timeout", get_parent(), "_damage_hull") #Need changing if not child to the world
	_hull_damage_timer.start()
	_spawn_timer.start(_spawn_time + _rng.randf_range(-_time_offset, _time_offset))

func _spawn():
	if _enemies_spawned < _max_spawned:
		var spawned_enemy = Global.instance_node(_enemy, global_position, Global._node_creation_parent)
		spawned_enemy._set_target_position(global_position + Vector2(sign(randi() % 2 - 0.5) * (_minimum_target.x + _rng.randf_range(0, _target_offset.x)), sign(randi() % 2 - 0.5) * (_minimum_target.y + _rng.randf_range(0, _target_offset.y))))
		spawned_enemy.connect("_enemy_killed", self, "_enemy_killed")
		_enemies_spawned += 1
		_spawn_timer.start(_spawn_time + _rng.randf_range(-_time_offset, _time_offset))

func _set_spawner(spawner):
	_spawner = spawner

func _bullet_hit(damage, _knockback, _bullet_velocity, bullet_origin):
	_influence(bullet_origin)
	_health -= damage
	if _health <= 0:
		var breach = Global.instance_node(_hullbreach, global_position, Global._node_creation_parent)
		breach._set_spawner(_spawner)
		queue_free()

func _influence(target_position):
	var bodies = _influence_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body._set_target_position(target_position)

func _enemy_killed():
	if _enemies_spawned >= _max_spawned:
		_spawn_timer.start(_spawn_time + _rng.randf_range(-_time_offset, _time_offset))
	_enemies_spawned -= 1

func _damage_hull():
	print("Self damage")
