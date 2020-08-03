extends Node
class_name MapTile

const Type_Undefined = 0;
const Type_Base = 1;
const Type_Spawn = 2;
const Type_Open = 3;
const Type_Wall = 4;

var mesh = null;
var offset = null;
var solid = false;
var pointID;
var pointWeight;
var targetDistance;
var node = null;
var typeID = null;

func _init():
	targetDistance = -1;
	typeID = Type_Undefined;

func GetNode():
	return node;

func GetPointID():
	return pointID;

func GetTypeID():
	return typeID;

func Setup(meshInstance,newTypeID):
	mesh = meshInstance;
	typeID = newTypeID;
	meshInstance.get_parent().remove_child(meshInstance);
	var aabb = mesh.get_aabb();
	offset = Vector3(aabb.position.x,0,aabb.position.z);
	print(offset);
	#offset = Vector3(-.5,0,-.5);
	
	
