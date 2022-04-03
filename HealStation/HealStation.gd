extends StaticBody2D

onready var _healtimer : Timer = $HealTimer
export var _heal_time : float = 0.5

func _ready():
	add_to_group("HealStation")
	_healtimer.connect("timeout", self, "_heal_player")
	_healtimer.wait_time = _heal_time

func _interact():
	_healtimer.autostart = true
	_healtimer.start()

func _stop_interaction():
	_healtimer.autostart = false
	_healtimer.stop()
	pass

func _heal_player():
	Global._player._heal()
