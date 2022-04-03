extends StaticBody2D

func _ready():
	add_to_group("WeaponRacks")

func _interact():
	Global._player._swap_weapon()
