class_name MapTile


var mesh = null;
var offset = null;


func NewInstance(offsetX,offsetZ):
	
	var container = Spatial.new();
	var newMesh = MeshInstance.new();
	newMesh.mesh = mesh.get_mesh();
	container.add_child(newMesh);
	var finalPos = Vector3(offsetX-offset.x,0,offsetZ-offset.z);
	container.global_transform.origin = finalPos;
	return container;


func Setup(meshInstance):
	mesh = meshInstance;
	print("setup tile " + mesh.get_name());
	var aabb = mesh.get_aabb();
	offset = Vector3(aabb.position.x,0,aabb.position.z);
	mesh.transform.origin.x += 1;
	meshInstance.get_parent().remove_child(meshInstance);
	
