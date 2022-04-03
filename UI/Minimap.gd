extends Control

export var _map_size : Vector2 = Vector2(50, 50)
onready var _map : TextureRect = $Minimap
export var _player_marker_resource : PackedScene
export var _h_door_marker_resource : PackedScene
export var _v_door_marker_resource : PackedScene
var _player_marker : Control
var _h_door_markers : Array = []
var _v_door_markers : Array = []

func _ready():
	var world = get_parent().get_parent()
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	
	dynImage.create(_map_size.x, _map_size.y,false,Image.FORMAT_RGB8)
	dynImage.fill(Color(0, 0, 0, 1))
	dynImage.lock()
	
	var world_floor_positions = world.get_node("Floor").get_used_cells()
	for cell in world_floor_positions:
		dynImage.set_pixel(cell.x, cell.y, Color.red)
	
	var world_walls_positions = world.get_node("Walls").get_used_cells()
	for cell in world_walls_positions:
		dynImage.set_pixel(cell.x, cell.y, Color.purple)
	
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

func _sync_player(_position):
	_player_marker.rect_global_position = rect_global_position + (_position/16).floor() 

func _sync_h_door(is_open, index):
	_h_door_markers[index]._set_open(is_open)

func _sync_v_door(is_open, index):
	_v_door_markers[index]._set_open(is_open)
