extends Node
class_name MapTile

enum Type {Base,Spawn};

var mesh = null;
var offset = null;
var solid = false;
var pointID;
var pointWeight;
var targetDistance;
var node = null;

func _init():
	targetDistance = -1;

func GetNode():
	return node;

func GetPointID():
	return pointID;

func Setup(meshInstance):
	mesh = meshInstance;
	meshInstance.get_parent().remove_child(meshInstance);
	var aabb = mesh.get_aabb();
	offset = Vector3(aabb.position.x,0,aabb.position.z);
	
	
