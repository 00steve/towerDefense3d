extends Node
class_name MapGenerator

var MapTile = load("res://util/MapTile.gd");

var gridSize;
var grid;

var baseGeometry;
var tileLibrary = [];

var mapNode = null;

func GenerateMap(ground,gridSize):
	self.gridSize = gridSize;
	baseGeometry = ground;
	ParseGeometry();
	GenerateLayout();
	GenerateModel();
	


	print("generate map");





func GenerateLayout():
	grid = [];
	grid.resize(gridSize);
	for x in range(0,gridSize):
		grid[x] = [];
		grid[x].resize(gridSize);
		for y in range(0,gridSize):
			var tIndex = randi() % tileLibrary.size();
			print("use tileLibrary[" + String(tIndex) + "] at offset (" + String(x) + "," + String(y) + ")");
			grid[x][y] = tileLibrary[tIndex].NewInstance(x,y);
			print(grid[x][y]);
		
		
func GenerateModel():
	mapNode = Spatial.new();
	mapNode.name = "mapGeometry";
	for x in range(0,gridSize):
		for y in range(0,gridSize):
			print("Assign tile to map at offset (" + String(x) + "," + String(y) + ")");
			mapNode.add_child(grid[x][y]);

	print("map geom added to mapNodes object");
		
		
func GetMapNode():
	return mapNode;
		
		
func ParseGeometry():
	for c in baseGeometry.get_children():
		if !c.is_class("MeshInstance"):
			print("not a mesh");
			continue;
		var mapTile = MapTile.new();
		mapTile.Setup(c);
		var cLibInd = tileLibrary.size();
		print("tile count : " + String(cLibInd));
		tileLibrary.append(mapTile);
