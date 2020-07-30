#warning-ignore-all:unused_variable

extends Spatial

const HTerrain = preload("res://addons/zylann.hterrain/hterrain.gd");
const HTerrainData = preload("res://addons/zylann.hterrain/hterrain_data.gd");

var grass_texture = load("res://img/ground/grass.jpg");
var sand_texture = load("res://img/ground/sand.png");
var leaves_texture = load("res://img/ground/leaves.png");


var ground = null;
var water_height = -.8;
var ground_height = 0;
var hill_height = .65;

var grid;

var mapGenerator = preload("res://util/MapGenerator.gd").new();


func _input(event):
	if Input.is_action_pressed("regenerate_map"):
		RegenerateMap();


# Called when the node enters the scene tree for the first time.
func _ready():
	grid = [];
	grid.resize(24);
	for g in grid:
		g = [];
		g.resize(24);
	
	
	mapGenerator.GenerateMap();

	
func RegenerateMap():
		# Create terrain resource and give it a size.
	# It must be either 513, 1025, 2049 or 4097.
	var terrain_data = HTerrainData.new()
	terrain_data.resize(32);
	
	var noise = OpenSimplexNoise.new();
	randomize();
	noise.seed = randi();
	noise.persistence = 10;
	var noise_multiplier = 1.0;
	

	# Get access to terrain maps you want to modify
	var heightmap: Image = terrain_data.get_image(HTerrainData.CHANNEL_HEIGHT)
	var normalmap: Image = terrain_data.get_image(HTerrainData.CHANNEL_NORMAL)
	var splatmap: Image = terrain_data.get_image(HTerrainData.CHANNEL_SPLAT)
	
	heightmap.lock()
	normalmap.lock()
	splatmap.lock()
	
	# Generate terrain maps
	# Note: this is an example with some arbitrary formulas,
	# you may want to come up with your own
	for z in heightmap.get_height():
		for x in heightmap.get_width():
			
			# Generate height
			var h = noise_multiplier * noise.get_noise_2d(x, z);
			if(h > hill_height):
				h = 5;
			else: 
				if(h < water_height):
					h =-5;
				else:
					if(h <= hill_height && h > ground_height):
						var dist = hill_height - ground_height;
						h = ((h - ground_height) / (hill_height - ground_height)) * 2 - 1;
						h = sin(h);
						h = sin(h) * 2.5 + 2.5;


						
			
			# Getting normal by generating extra heights directly from noise,
			# so map borders won't have seams in case you stitch them
			var h_right = noise_multiplier * noise.get_noise_2d(x + 0.1, z)
			var h_forward = noise_multiplier * noise.get_noise_2d(x, z + 0.1)
			var normal = Vector3(h - h_right, 0.1, h_forward - h).normalized()
			
			# Generate texture amounts
			# Note: the red channel is 1 by default
			var splat = splatmap.get_pixel(x, z)
			var slope = 4.0 * normal.dot(Vector3.UP) - 2.0
			# Sand on the slopes
			var sand_amount = clamp(1.0 - slope, 0.0, 1.0)
			# Leaves below sea level
			var leaves_amount = clamp(0.0 - h, 0.0, 1.0)
			splat = splat.linear_interpolate(Color(0,1,0,0), sand_amount)
			splat = splat.linear_interpolate(Color(0,0,1,0), leaves_amount)

			heightmap.set_pixel(x, z, Color(h, 0, 0))
			normalmap.set_pixel(x, z, HTerrainData.encode_normal(normal))
			splatmap.set_pixel(x, z, splat)
	
	heightmap.unlock()
	normalmap.unlock()
	splatmap.unlock()
	
	# Commit modifications so they get uploaded to the graphics card
	var modified_region = Rect2(Vector2(), heightmap.get_size())
	terrain_data.notify_region_change(modified_region, HTerrainData.CHANNEL_HEIGHT)
	terrain_data.notify_region_change(modified_region, HTerrainData.CHANNEL_NORMAL)
	terrain_data.notify_region_change(modified_region, HTerrainData.CHANNEL_SPLAT)

	# Create terrain node
	var terrain = HTerrain.new()
	terrain.set_shader_type(HTerrain.SHADER_CLASSIC4_LITE)
	terrain.set_data(terrain_data)
	terrain.set_ground_texture(0, HTerrain.GROUND_ALBEDO_BUMP, grass_texture)
	terrain.set_ground_texture(1, HTerrain.GROUND_ALBEDO_BUMP, sand_texture)
	terrain.set_ground_texture(2, HTerrain.GROUND_ALBEDO_BUMP, leaves_texture);
	
	if ground != null:
		remove_child(ground);
	
	ground = terrain;
	add_child(ground);
	
	# No need to call this, but you may need to if you edit the terrain later on
	#terrain.update_collider()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
