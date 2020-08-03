class_name MapGrid


var GridSize = null;
var MapNode = null;
var Grid = null;
var GridGeometry = null;
var centerPoint;

func _init(newGridSize):
	SetGridSize(newGridSize);
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


func GetCenterPoint():
	return centerPoint;

func GetModel():
	return MapNode;


func SetGridSize(newGridSize):
	GridSize = newGridSize;
	centerPoint = Vector3(GridSize.x / 2,0,GridSize.y / 2);
	Grid = [];
	Grid.resize(GridSize.x);
	GridGeometry = [];
	GridGeometry.resize(GridSize.x);
	for x in range(0,GridSize.x):
		Grid[x] = [];
		Grid[x].resize(GridSize.y);
		GridGeometry[x] = [];
		GridGeometry[x].resize(GridSize.y);



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
