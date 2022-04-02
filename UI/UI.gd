extends CanvasLayer

onready var _healthbar = $Healthbar

func _ready():
	Global._UI = self
	
func _exit_tree():
	Global._UI = null

func _update_max_health(max_health):
	_healthbar.max_value = max_health

func _update_healthbar(health):
	_healthbar.value = health
