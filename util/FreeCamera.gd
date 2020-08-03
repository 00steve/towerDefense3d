extends ClippedCamera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cameraVelocity;
var newCameraVelocity;
var cameraPosition;
var cameraRotation;
var focalPoint;

# Called when the node enters the scene tree for the first time.
func _ready():
	cameraRotation = Vector3(-25,0,0);
	cameraPosition = Vector3(0,10,0);
	cameraVelocity = Vector3(0,0,0);
	newCameraVelocity = Vector3(0,0,0);
	if(focalPoint == null):
		focalPoint = Vector3(0,0,0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cameraVelocity = (cameraVelocity * 3 + newCameraVelocity) / 4;
	
	cameraRotation.y += cameraVelocity.x * delta;
	cameraPosition = Vector3(sin(cameraRotation.y)*15,7,cos(cameraRotation.y)*15);
	#cameraPosition = cameraPosition + cameraVelocity * delta;
	self.transform.origin = cameraPosition + focalPoint;
	self.transform = self.transform.looking_at(focalPoint,Vector3(0,1,0));
	

func _input(event):
	newCameraVelocity = Vector3(0,0,0);
	if(Input.is_key_pressed(KEY_W)):
		newCameraVelocity.z -= 1;
	if(Input.is_key_pressed(KEY_S)):
		newCameraVelocity.z += 1;
	if(Input.is_key_pressed(KEY_A)):
		newCameraVelocity.x -= 1;
	if(Input.is_key_pressed(KEY_D)):
		newCameraVelocity.x += 1;
		
		
func  SetFocalPoint(position):
	print("focal point : " + String(position));
	focalPoint = position;
