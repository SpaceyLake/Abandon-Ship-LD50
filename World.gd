extends Node2D

export var _max_hull_integrity : int = 100
export var _max_oxygen_level : int = 100
export var _total_crew : int = 100
export var _evacuation_time : float = 2
var _hull_integrity : int
var _oxygen_level : int
var _evacuated_crew : int
onready var _evacuation_timer : Timer = $EvacuationTimer

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

func _damage_hull():
	_hull_integrity -= 1
	Global._UI._set_hull_integrity(_hull_integrity)

func _evacuate():
	_evacuated_crew += 1
	Global._UI._set_evacuated_crew(_evacuated_crew)
	_evacuation_timer.start(_evacuation_time)

func _exit_tree():
	Global._node_creation_parent = null
