extends StaticBody2D

var _spawner = null
export var _max_health : int = 5
var _health : int
export var _oxygen_drain_time : float = 1

onready var _oxygen_drain_timer : Timer = $OxygenDrainTimer

func _ready():
	var _rng = RandomNumberGenerator.new()
	_rng.randomize()
	$Sprite.frame = _rng.randi_range(0, 5)
	add_to_group("Enemy")
	_health = _max_health
	_oxygen_drain_timer.wait_time = _oxygen_drain_time
	_oxygen_drain_timer.one_shot = false
	_oxygen_drain_timer.autostart = true
	_oxygen_drain_timer.connect("timeout", get_parent(), "_drain_oxygen") #Need changing if not child to the world
	_oxygen_drain_timer.start()
	get_parent()._damage_hull_arbitrary(5)

func _set_spawner(spawner):
	_spawner = spawner

func _bullet_hit(_damage, _knockback, _bullet_velocity, _bullet_origin):
	pass

func _foam_hit(repair, _knockback, _bullet_velocity, _bullet_origin):
	_health -= repair
	if _health <= 0:
		_spawner._hazard_fixed()
		get_parent()._fix_hull_arbitrary(3)
		queue_free()
