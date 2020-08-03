extends Node
class_name MapGenerator

var MapTile = load("res://util/MapTile.gd");
var MapGrid = load("res://util/MapGrid.gd");

var layout;
var parsedGeometry = false;

var baseGeometry;
var tileLibrary = [];

var mapNode = null;
var mapGrid = null;

func GenerateMap(ground,newGridSize):
	mapGrid = MapGrid.new(newGridSize);
	baseGeometry = ground;
	tileLibrary.resize(16);
	if !parsedGeometry:
		ParseGeometry();
	GenerateLayout();
	GenerateModel();

func GenerateLayout():
	for x in range(0,mapGrid.GridSize.x):
		for z in range(0,mapGrid.GridSize.y):
			mapGrid.Grid[x][z] = 1;

	for x in range(0,mapGrid.GridSize.x):
		for z in range(0,mapGrid.GridSize.y):
			mapGrid.GridGeometry[x][z] = tileLibrary[mapGrid.Grid[x][z]].NewInstance(x,z,x*mapGrid.GridSize.x+z);

func GenerateModel():
	mapNode = Spatial.new();
	mapNode.name = "mapGeometry";
	for x in range(0,mapGrid.GridSize.x):
		for z in range(0,mapGrid.GridSize.y):
			
			print("Assign tile to map at offset (" + String(x) + "," + String(z) + ")");
			mapNode.add_child(mapGrid.GridGeometry[x][z]);

	print("map geom added to mapNodes object");
	print("Number of tiles : " + String(mapNode.get_children().size()));

func GetMapNode():
	return mapNode;

func GetMapGrid():
	return mapGrid;

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
	SetTile(int(mapGrid.GridSize.x/2),mapGrid.GridSize.y-1,3);
	#set spawn hold at top middle of map

func SetTile(x,z,tileIndex):
	ValidateGridUpdate(x,z,tileIndex);
	var oldTile = mapGrid.GridGeometry[x][z];
	if(oldTile):
		var isChild = mapNode.get_node(oldTile.get_name());
		if(isChild):
			isChild.free();
	mapGrid.Grid[x][z] = tileIndex;
	mapGrid.GridGeometry[x][z] = tileLibrary[mapGrid.Grid[x][z]].NewInstance(x,z,x*mapGrid.GridSize.x+z);
	mapNode.add_child(mapGrid.GridGeometry[x][z]);

func ValidateGridUpdate(x,z,tileIndex):
	#test.
	
	return true;
