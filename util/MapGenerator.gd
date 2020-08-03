extends Node
class_name MapGenerator

var MapTile = load("res://util/MapTile.gd");
var MapGrid = load("res://util/MapGrid.gd");
var MAStar = load("res://util/MAStar.gd");

var layout;
var parsedGeometry = false;
var tileLibrary = [];

var mapNode = null;
var mapGrid = null;
var mapValidate = null;

func _init(newBaseGeometry):
	tileLibrary.resize(16);
	ParseGeometry(newBaseGeometry);
	mapValidate = MAStar.new();

func GenerateMap(newGridSize):
	mapGrid = MapGrid.new(newGridSize);
	mapValidate.SetGrid(mapGrid);
	GenerateLayout();
	GenerateModel();

func GenerateLayout():
	for x in range(0,mapGrid.GridSize.x):
		for z in range(0,mapGrid.GridSize.y):
			mapGrid.TileTypeID[x][z] = MapTile.Type_Open;
	var oCount;
	var xSize = mapGrid.GridSize.x;
	var zSize = mapGrid.GridSize.y;
	if(xSize > zSize):
		oCount = zSize-1;
	else:
		oCount = xSize-1;
	var rx;
	var rz;
	while(oCount > 0):
		rx = randi() % int(mapGrid.GridSize.x);
		rz = randi() % int(mapGrid.GridSize.y);
		mapGrid.TileTypeID[rx][rz] = MapTile.Type_Wall;
		oCount -= 1;

	for x in range(0,mapGrid.GridSize.x):
		for z in range(0,mapGrid.GridSize.y):
			mapGrid.Tile[x][z] = GenerateMapTileInstance(tileLibrary[mapGrid.TileTypeID[x][z]],x,z,x*mapGrid.GridSize.x+z);

func GenerateMapTileInstance(tile,offsetX,offsetZ,newId):
	#create all of the needed new instances of objects
	var mapTile = MapTile.new();
	var container = Spatial.new();
	var newMesh = MeshInstance.new();
	var newArea = Area.new();
	var newCollisionShape = CollisionShape.new();
	var newBoxShape = BoxShape.new();
	
	#set up the new mesh
	newMesh.mesh = tile.mesh.get_mesh();
	container.add_child(newMesh);
	#create an area for registering collisions
	container.add_child(newArea);
	
	#create the shape that the area uses for collisions
	newBoxShape.set_extents(Vector3(1,.1,1));
	newCollisionShape.set_shape(newBoxShape);
	newArea.add_child(newCollisionShape);
	
	#setup the container properties (the object that gets sent back as a "tile")
	var rotation = Vector3(0,0,0);
	#depending on the type, give it a rotation
	#if(tile.GetTypeID() == 1):#or tile.GetTypeID() == 2)
	rotation = Vector3(0,randi()%4*1.57079632679,0);
	newMesh.set_rotation(rotation);

	var finalPos = Vector3(
		offsetX - tile.offset.x,
		0,
		offsetZ - tile.offset.z);

	container.transform.origin = finalPos; 
	
	container.name = "grid" + String(offsetX) + "_" + String(offsetZ);
	
	#set up specific tile object properties
	mapTile.mesh = tile.mesh;
	mapTile.offset = tile.offset;
	mapTile.solid = tile.solid;
	mapTile.pointID = newId;
	mapTile.pointWeight = tile.pointWeight;
	#mapTile.tartgetDistance = -1;
	mapTile.node = container;
	return mapTile;

func GenerateModel():
	if(mapNode):
		mapNode.free();
	mapNode = Spatial.new();
	mapNode.name = "mapGeometry";
	for x in range(0,mapGrid.GridSize.x):
		for z in range(0,mapGrid.GridSize.y):
			mapNode.add_child(mapGrid.Tile[x][z].GetNode());

func GetMapNode():
	return mapNode;

func GetMapGrid():
	return mapGrid;

func ParseGeometry(baseGeometry):
	for c in baseGeometry.get_children():
		if !c.is_class("MeshInstance"):
			continue;
		var name = c.get_name();
		var index = int(name.substr(0,3));
		if index == 0:
			continue;
		var mapTile = MapTile.new();
		mapTile.Setup(c,index);
		tileLibrary[index] = mapTile;
	parsedGeometry = true;

func SetDefaultLayout():
	#set default base position bottom middle of map
	SetTile(int(mapGrid.GridSize.x/2),mapGrid.GridSize.y-1,MapTile.Type_Base);
	#set spawn hold at top middle of map
	SetTile(int(mapGrid.GridSize.x/2),0,MapTile.Type_Spawn);

func SetTile(x,z,tileIndex):
	ValidateGridUpdate(x,z,tileIndex);
	var oldTile = mapGrid.Tile[x][z];
	if(oldTile):
		var isChild = mapNode.get_node(oldTile.GetNode().get_name());
		if(isChild):
			isChild.free();
	mapGrid.TileTypeID[x][z] = tileIndex;
	mapGrid.Tile[x][z] = GenerateMapTileInstance(tileLibrary[mapGrid.TileTypeID[x][z]],x,z,x*mapGrid.GridSize.x+z);
	mapNode.add_child(mapGrid.Tile[x][z].GetNode());

func ValidateGridUpdate(x,z,tileIndex):
	print("validate grid update to tile (" + String(x) + "," + String(z) + ") type = " + String(tileIndex));
	#mapValidate.TestUpdate(x,z,tileIndex);
	return true;
