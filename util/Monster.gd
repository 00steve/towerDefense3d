extends Node
class_name Monster

var mapGrid = null;
var position;

func _init(newMapGrid,newPosition):
	mapGrid = newMapGrid;
	position = newPosition;
	print("new monster, on map grid : " + newMapGrid.get_name());

# Called when the node enters the scene tree for the first time.
func _ready():
	var mi = MeshInstance.new();
	mi.mesh = SphereMesh.new();
	mi.mesh.radius = .1;
	mi.mesh.height = .1;
	self.add_child(mi);
	mi.transform.origin = position;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
