extends Node
class_name Tower

#objects
var origin;
var map;
var tile;
var random = null;




func _init(newTile):
	tile = newTile;
	random = RandomNumberGenerator.new();
	
	
	
func _ready():
	origin = self.get_parent().transform.origin;
	var mi = MeshInstance.new();
	mi.mesh = SphereMesh.new();
	mi.mesh.radius = .1;
	mi.mesh.height = .1;
	self.add_child(mi);
	mi.transform.origin = origin;
	#store a reference to the mapgrid
	map = self.get_parent().get_parent().get_parent();
	print("add tower");


func _process(delta):
	pass;
