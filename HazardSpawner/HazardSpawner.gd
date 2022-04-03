extends Node2D

signal _hazard_fixed()
signal _sync_map(exists, hazard)

export(Array, PackedScene) var hazards
var _rng = RandomNumberGenerator.new()
var _hazard_type : int = -1

func _ready():
	_rng.randomize()
	add_to_group("Hazard")

func _spawn_hazard():
	var hazard_randomization = _rng.randi_range(0, 3)
	if hazard_randomization == 0:
		_hazard_type = 1
	else:
		_hazard_type = 0
	var hazard = Global.instance_node(hazards[_hazard_type], global_position, Global._node_creation_parent)
	hazard._set_spawner(self)
	emit_signal("_sync_map", true, _hazard_type)

func _hazard_fixed():
	emit_signal("_hazard_fixed")
	emit_signal("_sync_map", false, _hazard_type)
	_hazard_type = -1

func _spawn_breach():
	_hazard_type = 1
	emit_signal("_sync_map", true, _hazard_type)
	var breach = Global.instance_node(hazards[_hazard_type], global_position, Global._node_creation_parent)
	breach._set_spawner(self)
