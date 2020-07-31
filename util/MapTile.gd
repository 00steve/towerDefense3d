class_name MapTile

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mesh = null;
var container = null;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func GetTile():
	return container;

func NewInstance(offsetX,offsetY):
	
	container = Spatial.new();
	container.global_transform.origin = Vector3(offsetX,0,offsetY);
	container.add_child(mesh);
	return container;


func Setup(meshInstance):
	mesh = meshInstance;
	print("setup tile " + mesh.get_name());
	var aabb = mesh.get_aabb();
	var offset = Vector2(aabb.position.x,aabb.position.y);
	print (offset);
	print(mesh.global_transform.origin);
	mesh.transform.origin.x += 1;
	
	#container = Spatial.new();
	#container.add_child(mesh);
	
	meshInstance.get_parent().remove_child(meshInstance);
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
