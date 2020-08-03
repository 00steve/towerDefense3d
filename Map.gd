#warning-ignore-all:unused_variable
extends Spatial

#included classes
var MapGenerator = preload("res://util/MapGenerator.gd");
var MapGrid = load("res://util/MapGrid.gd");

var mapGenerator = null;
var mapGrid = null;
var ground = null;

func _init():
	pass;

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_R:
		GenerateMap();


# Called when the node enters the scene tree for the first time.
func _ready():
	mapGenerator = MapGenerator.new($ground);
	$ground.free();
	GenerateMap();



func GenerateMap():
	var ng = self.has_node("mapGeometry");
	if(ng):
		var g = $mapGeometry;
		self.remove_child($mapGeometry);
		g.free();
	var width = randi() % 3 * 2 + 7;
	mapGenerator.GenerateMap(Vector2(width,13));
	mapGenerator.SetDefaultLayout();
	mapGrid = mapGenerator.GetMapGrid();
		
	self.add_child(mapGenerator.GetMapNode());
	print("children count : " + String(self.get_children().size()));

	self.get_parent().get_node("Camera").SetFocalPoint(mapGrid.GetCenterPoint());
