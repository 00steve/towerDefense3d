extends Node
class_name Spawner

var origin;
var meshInstance;
var mesh;
var surfaceMaterial;

var timeBetweenSpawns;
var timeUntilNextSpawn;
var spawnCount;

func _init():
	timeBetweenSpawns = 1;
	timeUntilNextSpawn = timeBetweenSpawns;
	spawnCount = 0;

func _ready():


	var mi = MeshInstance.new();
	mi.mesh = SphereMesh.new();
	mi.mesh.radius = .1;
	mi.mesh.height = .1;
	self.add_child(mi);
	#self.transform.origin = self.get_parent().get_parent().TileOffset;
	mi.transform.origin = self.get_parent().transform.origin;
	
	print("add spawner");
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	timeUntilNextSpawn -= delta;
	if(timeUntilNextSpawn > 0):
		return;
	timeUntilNextSpawn += timeBetweenSpawns;
	spawnCount += 1;
	print("spawn: " + String(spawnCount));
	
