extends CanvasLayer

onready var _healthbar = $Healthbar/Healthbar
onready var _oxygenbar = $Oxygenbar/Oxygenbar
onready var _hullbar = $Hullbar/Hullbar
onready var _evacuation_numbers = $Evacuationbar/EvacuationBackground.get_children()

func _ready():
	Global._UI = self
	
func _exit_tree():
	Global._UI = null

func _set_max_health(max_health):
	_healthbar.max_value = max_health

func _set_healthbar(health):
	_healthbar.value = health

func _set_max_oxygen(max_oxygen):
	_oxygenbar.max_value = max_oxygen
	
func _set_oxygen_level(oxygen_level):
	_oxygenbar.value = oxygen_level

func _set_max_hull(max_hull):
	_hullbar.max_value = max_hull

func _set_hull_integrity(hull_integrity):
	_hullbar.value = hull_integrity

func _set_total_crew(total_crew):
	if total_crew > 999: total_crew = 999
	_evacuation_numbers[3].frame = floor(total_crew/100)
	_evacuation_numbers[4].frame = floor((total_crew%100)/10)
	_evacuation_numbers[5].frame = total_crew%10

func _set_evacuated_crew(evacuated_crew):
	if evacuated_crew > 999: evacuated_crew = 999
	_evacuation_numbers[0].frame = floor(evacuated_crew/100)
	_evacuation_numbers[1].frame = floor((evacuated_crew%100)/10)
	_evacuation_numbers[2].frame = evacuated_crew%10
