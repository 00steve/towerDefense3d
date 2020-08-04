extends Node
class_name Spawner


var Monster = load("res://util/Monster.gd");

#objects
var origin;
var map;
var random = null;

#settings
var timeBetweenSpawns;
var timeUntilNextSpawn;
var spawnRadius;

#statistics
var spawnCount;


func _init():
	random = RandomNumberGenerator.new();
	
	timeBetweenSpawns = 1;
	timeUntilNextSpawn = timeBetweenSpawns;
	spawnRadius = .25;
	
	spawnCount = 0;
	
func _ready():
	origin = self.get_parent().transform.origin;
	var mi = MeshInstance.new();
	mi.mesh = SphereMesh.new();
	mi.mesh.radius = .1;
	mi.mesh.height = .1;
	self.add_child(mi);
	mi.transform.origin = origin;
	#store a reference to the mapgrid
	map = self.get_parent().get_parent().get_parent();
	print("add spawner");
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	timeUntilNextSpawn -= delta;
	if(timeUntilNextSpawn > 0):
		return;
	timeUntilNextSpawn += timeBetweenSpawns;
	spawnCount += 1;
	Spawn();
	print("spawn: " + String(spawnCount));
	
func Spawn():
	var rot = random.randf_range(-3.14,3.14);
	var dist = random.randf_range(0,spawnRadius);
	var position = Vector3(origin.x + sin(rot)*dist, 0 ,origin.z + cos(rot)*dist);
	map.find_node("Monsters").add_child(Monster.new(map.mapGrid,position));
	pass;
