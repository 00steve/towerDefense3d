class_name MapTile

var mesh = null;
var offset = null;
var solid = false;
var pointID;
var pointWeight;


func GetPointID():
	return pointID;



func NewInstance(offsetX,offsetZ,newId):
	#create all of the needed new instances of objects
	var container = Spatial.new();
	var newMesh = MeshInstance.new();
	var newArea = Area.new();
	var newCollisionShape = CollisionShape.new();
	var newBoxShape = BoxShape.new();
	
	#set up the new mesh
	newMesh.mesh = mesh.get_mesh();
	container.add_child(newMesh);
	
	

	
	#create an area for registering collisions
	container.add_child(newArea);
	
	#create the shape that the area uses for collisions
	newBoxShape.set_extents(Vector3(1,.1,1));
	newCollisionShape.set_shape(newBoxShape);
	newArea.add_child(newCollisionShape);
	
	
	#setup the container properties (the object that gets sent back as a "tile")
	var finalPos = Vector3(offsetX-offset.x,0,offsetZ-offset.z);
	#don't use global_transform as the container isn't in the parent scene yet
	container.transform.origin = finalPos; 
	container.name = "grid" + String(offsetX) + "_" + String(offsetZ);
	
	#set up generic tile object properties
	pointID = newId;
	return container;


func Setup(meshInstance):
	mesh = meshInstance;
	meshInstance.get_parent().remove_child(meshInstance);
	
	var aabb = mesh.get_aabb();
	offset = Vector3(aabb.position.x,0,aabb.position.z);
	
	
