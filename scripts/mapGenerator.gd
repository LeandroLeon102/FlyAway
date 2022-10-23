extends Node
onready var parent = get_node("../..")

export (Vector2) var map_size = Vector2(64,37)
var initial_map_size = map_size
export (bool) var random_size = false
export var size_limits = [Vector2(), Vector2()]
export(String) var world_seed = ""
export (int) var noise_octaves = 1
export (int) var noise_period = 7
export (float) var noise_persistence = 0.7
export (float) var noise_lacunarity = 0.2
export (float) var noise_threshold = 0.1

export var border_size = 0


export (bool) var redraw setget redraw

var tile_map : TileMap
var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()

export (bool) var random_seed_generation = false

func _ready():
	randomize()
	self.tile_map = get_parent() as TileMap
	clear()
	generate()


func redraw(value=null):
	if self.tile_map == null:
		return
	clear()
	generate()

func clear():
	self.tile_map.clear() 
	
func generate():
	if random_size:
		randomize()
		map_size = Vector2(int(rand_range(size_limits[0].x, size_limits[1].x)), int(rand_range(size_limits[0].y, size_limits[1].y)))
	else:
		map_size = initial_map_size
	if self.random_seed_generation:
		randomize()
		self.world_seed = str(randi())
	self.simplex_noise.seed = self.world_seed.hash()
	self.simplex_noise.octaves = self.noise_octaves
	self.simplex_noise.period = self.noise_period
	self.simplex_noise.persistence = self.noise_persistence
	self.simplex_noise.lacunarity = self.noise_lacunarity
	
	for x in range(0, self.map_size.x):
		for y in range(0, self.map_size.y):
			if self.simplex_noise.get_noise_2d(x, y) >= self.noise_threshold:
				self._set_autotile(x, y)
				
	generate_borders(border_size)
	self.tile_map.update_dirty_quadrants()

	

func _set_autotile(x : int, y : int):
	self.tile_map.set_cell(x, y, self.tile_map.get_tileset().get_tiles_ids()[0], false, false, false, self.tile_map.get_cell_autotile_coord(x, y))
	self.tile_map.update_bitmask_area(Vector2(x, y))

func _process(delta):
	if Input.is_action_just_pressed('redraw'):
		redraw()
	if Input.is_action_just_pressed("savemap"):
		save_world("res://scenes/Maps/")


	
func get_pos(offset):
	var pos = Vector2(int(rand_range(0, self.map_size.x)), int(rand_range(0, self.map_size.y)))
	if self.tile_map.get_cell(pos.x, pos.y) == self.tile_map.INVALID_CELL and \
	self.tile_map.get_cell(pos.x - offset, pos.y) == self.tile_map.INVALID_CELL and self.tile_map.get_cell(pos.x + offset, pos.y) == self.tile_map.INVALID_CELL and \
	self.tile_map.get_cell(pos.x, pos.y - offset) == self.tile_map.INVALID_CELL and self.tile_map.get_cell(pos.x, pos.y + offset) == self.tile_map.INVALID_CELL:
			print()
			return Vector2(pos.x*16, pos.y*16)
	else:
		pos = get_pos(offset)
		return pos
		
func get_player_pos():
	var pos = Vector2(int(rand_range(0, self.map_size.x)), int(rand_range(0, self.map_size.y)))
	if self.tile_map.get_cell(pos.x, pos.y) == self.tile_map.INVALID_CELL:
			return Vector2(pos.x*16, pos.y*16)
	else:
		pos = get_player_pos()
		return pos
	
func save_world(path):
	
	var packed_scene = PackedScene.new()
#	var current_tilemap = get_parent().
#	var childs = current_tilemap.get_children()
#	for c in childs:
#		c.queue_free()
	packed_scene.pack(get_parent())

	var name = get_file_name(path)
	ResourceSaver.save(path + name + '.tscn', packed_scene)
		
func get_file_name(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	
	dir.list_dir_begin()
	var run = true
	while run:
		if dir.get_next() != '':
			files.append(1)
		else:
			break
	dir.list_dir_end()
	print(len(files) - 1)
	if len(files) == 0:
		return 'Map1'
	else:
		return 'Map' + str(len(files)-1)
		
func generate_grass():
	pass
			
func generate_borders(size):
	for x in range(0, self.map_size.x + 0):
		for y in range(-size, 0):
			self._set_autotile(x, y)
	for x in range(0, self.map_size.x + 0):
		for y in range(self.map_size.y, self.map_size.y + size):
			self._set_autotile(x, y)
	for y in range(0 - size, self.map_size.y + size):
		for x in range(-size, 0):
			self._set_autotile(x, y)
	for y in range(0-size, self.map_size.y + size):
		for x in range(self.map_size.x, self.map_size.x + size):
			self._set_autotile(x, y)

