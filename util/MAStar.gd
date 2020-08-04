extends Node
class_name MAStar

var MapTile = load("res://util/MapTile.gd");
var grid = null;

var tileQueue = [];


func _init():
	pass;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;
	


func Build():
	#if(grid.startTile.size()==0):
	#	print("no starts");
	#	return;
	if(grid.endTile.size()==0):
		print("no ends");
		return;

	ResetTiles();
	
	tileQueue = [];
	for i in grid.endTile:
		tileQueue.append(i);
		
	var currentTile = null;
	currentTile = tileQueue.pop_front();
	while(currentTile):
		#do work with tile
		ProcessTile(currentTile);
		#currentTile.node.transform.origin.y = currentTile.pathScore*.05;
		currentTile = tileQueue.pop_front();

func ProcessTile(tile):
	if(tile.linkedTile):
		tile.pathScore = tile.linkedTile.pathScore + 1;
	else:
		tile.pathScore = 1;
		tile.checked = true;
	var x = tile.TileOffset.x;
	var z = tile.TileOffset.z;
	if(x < grid.GridSize.x-1):
		CheckPathTile(grid.Tile[x+1][z],tile);
		#print("\t-right = open");
	if(x > 0):
		CheckPathTile(grid.Tile[x-1][z],tile);
		#print("\t-left = open");
	if(z < grid.GridSize.y-1):
		CheckPathTile(grid.Tile[x][z+1],tile);
		#print("\t-back = open");
	if(z > 0):
		CheckPathTile(grid.Tile[x][z-1],tile);
		#print("\t-front = open");
	
func CheckPathTile(tile,linkTile):
	if(!tile.solid and !tile.checked):
		tileQueue.push_back(tile);
	tile.checked = true;
	tile.linkedTile = linkTile;
	
func ResetTiles():
	for x in range(0,grid.GridSize.x):
		for z in range(0,grid.GridSize.y):
			grid.Tile[x][z].checked = false;
			grid.Tile[x][z].pathScore = -1;
			grid.Tile[x][z].linkedTile = null;
func SetGrid(newGrid):
	grid = newGrid;
	pass;
