extends Node
class_name MapGenerator

var MapTile = load("res://util/MapTile.gd");

var gridSize;
var layout;
var grid;
var gridGeometry;
var parsedGeometry = false;

var baseGeometry;
var tileLibrary = [];

var mapNode = null;
var pathUtil;

func GenerateMap(ground,newGridSize):
	gridSize = newGridSize;
	baseGeometry = ground;
	tileLibrary.resize(16);
	if !parsedGeometry:
		ParseGeometry();
	GenerateLayout();
	GenerateModel();
	


	print("generate map");





func GenerateLayout():
	grid = [];
	grid.resize(gridSize);
	gridGeometry = [];
	gridGeometry.resize(gridSize);
	for x in range(0,gridSize):
		grid[x] = [];
		grid[x].resize(gridSize);
		gridGeometry[x] = [];
		gridGeometry[x].resize(gridSize);
		for z in range(0,gridSize):
			#grid[x][z] = 1;
			#var tIndex = randi() % tileLibrary.size() + 1;+ ")");
			#default every tile to grass
			grid[x][z] = 1;
	
	for x in range(0,gridSize):
		for z in range(0,gridSize):	
			gridGeometry[x][z] = tileLibrary[grid[x][z]].NewInstance(x,z,x*gridSize+z);
	
	pathUtil = MAStar.new(grid);
	
	
func GenerateModel():
	mapNode = Spatial.new();
	mapNode.name = "mapGeometry";
	for x in range(0,gridSize):
		for z in range(0,gridSize):
			#print("Assign tile to map at offset (" + String(x) + "," + String(z) + ")");
			mapNode.add_child(gridGeometry[x][z]);

	print("map geom added to mapNodes object");
	print("Number of tiles : " + String(mapNode.get_children().size()));
		
func GetMapNode():
	return mapNode;
		
		
func ParseGeometry():
	for c in baseGeometry.get_children():
		if !c.is_class("MeshInstance"):
			continue;
		var name = c.get_name();
		var index = int(name.substr(0,3));
		if index == 0:
			continue;
		var mapTile = MapTile.new();
		mapTile.Setup(c);
		var cLibInd = tileLibrary.size();
		tileLibrary[index] = mapTile;

	parsedGeometry = true;

func SetDefaultLayout():
	#set default base position bottom middle of map
	SetTile(int(gridSize/2),gridSize-1,3);
	#set spawn hold at top middle of map

func SetTile(x,z,tileIndex):
	ValidateGridUpdate(x,z,tileIndex);
	var oldTile = gridGeometry[x][z];
	if(oldTile):
		var isChild = mapNode.get_node(oldTile.get_name());
		if(isChild):
			isChild.free();
	grid[x][z] = tileIndex;
	gridGeometry[x][z] = tileLibrary[grid[x][z]].NewInstance(x,z,x*gridSize+z);
	mapNode.add_child(gridGeometry[x][z]);

func ValidateGridUpdate(x,z,tileIndex):
	#test.
	
	return true;
