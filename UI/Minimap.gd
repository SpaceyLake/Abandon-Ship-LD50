extends TextureRect

export var _map_size : Vector2 = Vector2(50, 50)

func _ready():
	var world = get_parent().get_parent().get_parent()
	var world_floor_positions = world.get_node("Floor").get_used_cells()
	var world_walls_positions = world.get_node("Walls").get_used_cells()
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	
	dynImage.create(_map_size.x, _map_size.y,false,Image.FORMAT_RGB8)
	dynImage.fill(Color(0, 0, 0, 1))
	dynImage.lock()
	
	for cell in world_floor_positions:
		dynImage.set_pixel(cell.x, cell.y, Color.red)
	
	for cell in world_walls_positions:
		dynImage.set_pixel(cell.x, cell.y, Color.purple)
	
	imageTexture.create_from_image(dynImage)
	self.texture = imageTexture
	
	imageTexture.resource_name = "The created texture!"
