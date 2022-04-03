extends Node2D

signal _hazard_fixed()

export(Array, PackedScene) var hazards
var _rng = RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	add_to_group("Hazard")

func _spawn_hazard():
	var hazard = Global.instance_node(hazards[_rng.randi_range(0, hazards.size() - 1)], global_position, Global._node_creation_parent)
	hazard._set_spawner(self)

func _hazard_fixed():
	emit_signal("_hazard_fixed")
