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
	if(grid.startTile.size()==0):
		print("no starts");
		return;
	if(grid.endTile.size()==0):
		print("no ends");
		return;
	#print("Start points: " + String(grid.startTile.size()));
	#print("End points: " + String(grid.endTile.size()));
	#print("build paths");
	
	ResetTiles();
	tileQueue = [];
	for i in grid.endTile:
		tileQueue.append(i);
		
	#get start and end tiles from the grid
	
	#print("grid size " + String(grid.size()));
	var currentTile = null;
	#tileQueue.push_back(grid[xEnd][zEnd]);
	#var currentTile;
	currentTile = tileQueue.pop_front();
	while(currentTile):
		#do work with tile
		ProcessTile(currentTile);
		currentTile = tileQueue.pop_front();

func ProcessTile(tile):
	print("----------tile---------");
	print("offset("+String(tile.TileOffset.x)+","+String(tile.TileOffset.z)+")");
	print("gridsize(" + String(grid.GridSize.x) + "," + String(grid.GridSize.y)+")");
	var x = tile.TileOffset.x;
	var z = tile.TileOffset.z;
	if(x < grid.GridSize.x-1 and grid.Tile[x+1][z].solid == false):
		print("\t-right = open");
	if(x > 0 and grid.Tile[x-1][z].solid == false):
		print("\t-left = open");
	if(z < grid.GridSize.y-1 and grid.Tile[x][z+1].solid == false):
		print("\t-back = open");
	if(z > 0 and grid.Tile[x][z-1].solid == false):
		print("\t-front = open");
	
	
func ResetTiles():
	for x in range(0,grid.GridSize.x):
		for z in range(0,grid.GridSize.y):
			grid.Tile[x][z].checked = false;

	
func SetGrid(newGrid):
	grid = newGrid;
	pass;
