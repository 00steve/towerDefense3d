#warning-ignore-all:unused_variable

extends Spatial



var mapGenerator = preload("res://util/MapGenerator.gd").new();


func _input(event):
	if Input.is_action_pressed("regenerate_map"):
		GenerateMap();


# Called when the node enters the scene tree for the first time.
func _ready():
	GenerateMap();



func GenerateMap():
	mapGenerator.GenerateMap($ground,6);
	self.remove_child($ground);
	self.add_child(mapGenerator.GetMapNode());
	#mapGenerator.GenerateMap($Ground1);
	
