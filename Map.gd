#warning-ignore-all:unused_variable
extends Spatial
var mapGenerator = preload("res://util/MapGenerator.gd").new();
var MapGrid = load("res://util/MapGrid.gd");

var mapGrid = null;
var ground = null;


func _input(event):
	if Input.is_action_pressed("regenerate_map"):
		GenerateMap();


# Called when the node enters the scene tree for the first time.
func _ready():
	GenerateMap();



func GenerateMap():
	mapGenerator.GenerateMap($ground,Vector2(5,9));
	mapGenerator.SetDefaultLayout();
	var ng = self.get_node("ground");
	if(ng):
		var g = $ground;
		self.remove_child($ground);
		g.free();
	else:
		var g = $mapGeometry;
		self.remove_child($mapGeometry);
		g.free();
	
	mapGrid = mapGenerator.GetMapGrid();
		
	self.add_child(mapGenerator.GetMapNode());
	print("children count : " + String(self.get_children().size()));

	self.get_parent().get_node("Camera").SetFocalPoint(mapGrid.GetCenterPoint());
