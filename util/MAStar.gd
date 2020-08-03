extends Node
class_name MAStar

var MapTile = load("res://util/MapTile.gd");
var grid = null;

func _init():
	pass;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;
	
var tileQueue = [];

##pass in an a 2d array of MapTile classes
func BuildPath(xStart,zStart,xEnd,zEnd):
	print("grid size " + String(grid.size()));
	ResetTiles();
	tileQueue.push_back(grid[xEnd][zEnd]);
	var currentTile;
	currentTile = tileQueue.pop_front();
	while(currentTile):
		#do work with tile
		ProcessTile(currentTile);
		currentTile = tileQueue.pop_front();

func ProcessTile(tile):
	
	pass;
	
	
func ResetTiles():
	#for x in grid.Tiles
	pass;
	
func SetGrid(newGrid):
	grid = newGrid;
