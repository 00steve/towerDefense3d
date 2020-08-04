extends Node
class_name Monster

#objects
var mapGrid = null;
var position;
var meshInstance;
var random = null;

#settings
var movementSpeed;
var targetRadius;
var wanderRatio;
var height;

#state
var targetTile = null;
var targetPosition = null;
var angleToTarget = null;
var distanceToTarget;
var lowestScore;

func _init(newMapGrid,targetTile,newPosition):
	random = RandomNumberGenerator.new();
	random.randomize();
	
	movementSpeed = 1;
	targetRadius = .5;
	wanderRatio = 2;
	height = .1;
	
	mapGrid = newMapGrid;
	position = newPosition;
	targetPosition = position; #set it to the current position so it wants a new target
	distanceToTarget = 0;
	print("new monster, on map grid : " + newMapGrid.get_name());

# Called when the node enters the scene tree for the first time.
func _ready():
	meshInstance = MeshInstance.new();
	var mesh = SphereMesh.new();
	mesh.radius = .1;
	mesh.height = height;
	meshInstance.mesh = mesh;
	self.add_child(meshInstance);
	Move(.01);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(distanceToTarget < .03):
		PickTarget();
	
	Move(delta);
	
func Move(delta):
	var movementVector = (targetPosition-position);
	position = position + (movementVector.normalized() * delta * movementSpeed);
	meshInstance.transform.origin = position + Vector3(0,height*.5,0);
	distanceToTarget = (targetPosition-position).length();
	pass;

	
	
func PickTarget():
	#get four nearest tiles
	lowestScore = 9999;
	var pathScore;
	var tileIndex = Vector2(int(position.x),int(position.z));
	if(tileIndex.x > 0):
		CheckTile(mapGrid.Tile[tileIndex.x-1][tileIndex.y]);
	if(tileIndex.y > 0):
		CheckTile(mapGrid.Tile[tileIndex.x][tileIndex.y-1]);
	if(tileIndex.x+1 < mapGrid.GridSize.x):
		CheckTile(mapGrid.Tile[tileIndex.x+1][tileIndex.y]);
	if(tileIndex.y+1 < mapGrid.GridSize.y):
		CheckTile(mapGrid.Tile[tileIndex.x][tileIndex.y+1]);
		
	var rot = random.randf_range(-3.14,3.14);
	var dist = random.randf_range(0,targetRadius);
	targetPosition = targetTile.TileOffset + Vector3(.5 + sin(rot)*dist, 0 ,.5 + cos(rot)*dist);
		
	#figure out which tile we want to move to next, store that 
	#tile in the targetTile var, also, store the targetPosition, 
	#based on the targetTile TileOffset var.
	pass;
	
func CheckTile(tile):
	var pathScore = tile.pathScore;
	var wander = random.randf_range(-wanderRatio,wanderRatio);
	if(!tile.solid and pathScore < lowestScore + wander):
		lowestScore = pathScore;
		targetTile = tile;
