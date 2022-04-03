extends Node2D

export var _max_hull_integrity : int = 100
export var _max_oxygen_level : int = 100
export var _total_crew : int = 100
export var _evacuation_time : float = 2
export var _hazard_spawn_time : float = 10
export var _hazard_time_offset : float = 5
export var _oxygen_regen_time : float = 3
var _hull_integrity : int
var _oxygen_level : int
var _evacuated_crew : int
onready var _evacuation_timer : Timer = $EvacuationTimer
onready var _hazard_timer : Timer = $HazardTimer
onready var _oxygen_regen_timer : Timer = $OxygenRegenTimer
var _possible_hazards : Array = []
var _active_hazards : Array = []
var rng = RandomNumberGenerator.new()

func _ready():
	Global._node_creation_parent = self
	_hull_integrity = _max_hull_integrity
	_oxygen_level = _max_oxygen_level
	_evacuated_crew = 0
	Global._UI._set_max_oxygen(_max_oxygen_level)
	Global._UI._set_oxygen_level(_oxygen_level)
	Global._UI._set_max_hull(_max_hull_integrity)
	Global._UI._set_hull_integrity(_hull_integrity)
	Global._UI._set_total_crew(_total_crew)
	Global._UI._set_evacuated_crew(_evacuated_crew)
	_evacuation_timer.connect("timeout", self, "_evacuate")
	_evacuation_timer.start(_evacuation_time)
	_hazard_timer.connect("timeout", self, "_spawn_hazard")
	_oxygen_regen_timer.wait_time = _oxygen_regen_time
	_oxygen_regen_timer.one_shot = false
	_oxygen_regen_timer.autostart = true
	_oxygen_regen_timer.connect("timeout", self, "_regen_oxygen") #Need changing if not child to the world
	_oxygen_regen_timer.start()
	var children = get_children()
	for child in children:
		if child.is_in_group("Hazard"):
			_possible_hazards.append(child)
			child.connect("_hazard_fixed", self, "_hazard_fixed", [child])
	_possible_hazards.shuffle()
	_hazard_timer.start(_hazard_spawn_time + rng.randf_range(0, _hazard_time_offset))

func _spawn_hazard():
	if _possible_hazards.size() > 0:
		_possible_hazards.pop_front()._spawn_hazard()
		_hazard_timer.start(_hazard_spawn_time + rng.randf_range(0, _hazard_time_offset))

func _hazard_fixed(hazard):
	if _possible_hazards.size() == 0:
		_hazard_timer.start(_hazard_spawn_time + rng.randf_range(0, _hazard_time_offset))
	_possible_hazards.append(hazard)
	_possible_hazards.shuffle()

func _regen_oxygen():
	if _oxygen_level < _max_oxygen_level:
		_oxygen_level += 1
		Global._UI._set_oxygen_level(_oxygen_level)

func _drain_oxygen():
	_oxygen_level -= 1
	Global._UI._set_oxygen_level(_oxygen_level)

func _damage_hull():
	_hull_integrity -= 1
	Global._UI._set_hull_integrity(_hull_integrity)

func _damage_hull_arbitrary(damage):
	_hull_integrity -= damage
	Global._UI._set_hull_integrity(_hull_integrity)

func _fix_hull_arbitrary(fix):
	_hull_integrity += fix
	Global._UI._set_hull_integrity(_hull_integrity)

func _evacuate():
	var _evac = rng.randi_range(0, 10)
	if _evac > _total_crew-_evacuated_crew: _evac = _total_crew-_evacuated_crew
	_evacuated_crew += _evac
	Global._UI._set_evacuated_crew(_evacuated_crew)
	_evacuation_timer.start(_evacuation_time*_evac)

func _exit_tree():
	Global._node_creation_parent = null
