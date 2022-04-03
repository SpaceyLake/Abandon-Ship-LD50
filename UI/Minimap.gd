extends Control

export var _map_size : Vector2 = Vector2(50, 50)
onready var _map : TextureRect = $Minimap
export var _player_marker_resource : PackedScene
export var _h_door_marker_resource : PackedScene
export var _v_door_marker_resource : PackedScene
export var _weapon_rack_marker_resource : PackedScene
export var _control_panel_marker_resource : PackedScene
export var _enemy_spawner_marker_resource : PackedScene
export var _breach_marker_resource : PackedScene
export var _escape_pod_control_marker_resource : PackedScene
export var _heal_station_marker_resource : PackedScene
export var _background_color : Color = Color.black
export var _wall_color : Color = Color.purple
export var _floor_color : Color = Color.red
var _player_marker : Control
var _h_door_markers : Array = []
var _v_door_markers : Array = []
var _hazard_markers : Array = []
var _hazard_types : Array = []

func _ready():
	var world = get_parent().get_parent()
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	
	dynImage.create(_map_size.x, _map_size.y,false,Image.FORMAT_RGBA8)
	dynImage.fill(_background_color)
	dynImage.lock()
	
	var world_floor_positions = world.get_node("Floor").get_used_cells()
	for cell in world_floor_positions:
		dynImage.set_pixel(cell.x, cell.y, _floor_color)
	
	var world_walls_positions = world.get_node("Walls").get_used_cells()
	for cell in world_walls_positions:
		dynImage.set_pixel(cell.x, cell.y, _wall_color)
	
	imageTexture.create_from_image(dynImage)
	_map.texture = imageTexture
	
	imageTexture.resource_name = "Minimap"
	
	var player = world.get_node("Player")
	_player_marker = Global.instance_control_node(_player_marker_resource, rect_global_position + (player.global_position/16).floor(), self)
	player.connect("_sync_map", self, "_sync_player")
	
	var world_objects = world.get_children()
	for object in world_objects:
		if object.is_in_group("HDoors"):
			object.connect("_sync_map", self, "_sync_h_door", [_h_door_markers.size()])
			_h_door_markers.append(Global.instance_control_node(_h_door_marker_resource, rect_global_position + (object.global_position/16).floor(), self))
		if object.is_in_group("VDoors"):
			object.connect("_sync_map", self, "_sync_v_door", [_v_door_markers.size()])
			_v_door_markers.append(Global.instance_control_node(_v_door_marker_resource, rect_global_position + (object.global_position/16).floor(), self))
			pass
		if object.is_in_group("ControlPanels"):
			Global.instance_control_node(_control_panel_marker_resource, rect_global_position + (object.global_position/16).floor(), self)
		if object.is_in_group("WeaponRacks"):
			Global.instance_control_node(_weapon_rack_marker_resource, rect_global_position + (object.global_position/16).floor(), self)
		if object.is_in_group("Hazard"):
			object.connect("_sync_map", self, "_sync_hazard", [_hazard_markers.size(), object.global_position])
			_hazard_markers.append(null)
			_hazard_types.append(-1)
		if object.is_in_group("HealStation"):
			print("HealStation Found")
			Global.instance_control_node(_heal_station_marker_resource, rect_global_position + (object.global_position/16).floor(), self)
		if object.is_in_group("EscapePodControl"):
			Global.instance_control_node(_escape_pod_control_marker_resource, rect_global_position + (object.global_position/16).floor(), self)

func _sync_player(_position):
	_player_marker.rect_global_position = rect_global_position + (_position/16).floor() 

func _sync_h_door(is_open, index):
	_h_door_markers[index]._set_open(is_open)

func _sync_v_door(is_open, index):
	_v_door_markers[index]._set_open(is_open)

func _sync_hazard(exists, hazard, index, position):
	if exists:
		match hazard:
			0:
				if _hazard_markers[index] != null:
					_hazard_markers[index].queue_free()
					_hazard_markers[index] = null
				_hazard_markers[index] = Global.instance_control_node(_enemy_spawner_marker_resource, rect_global_position + (position/16).floor(), self)
			1:
				if _hazard_markers[index] != null:
					_hazard_markers[index].queue_free()
					_hazard_markers[index] = null
				_hazard_markers[index] = Global.instance_control_node(_breach_marker_resource, rect_global_position + (position/16).floor(), self)
		_hazard_types[index] = hazard
	else:
		if hazard == _hazard_types[index] and _hazard_markers[index] != null:
			_hazard_markers[index].queue_free()
			_hazard_markers[index] = null
			_hazard_types[index] = -1
