class_name MapGenerator


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func GenerateMap():
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	# Prepare attributes for add_vertex.
	st.add_normal(Vector3(0, 0, 1));
	st.add_uv(Vector2(0, 0));
	# Call last for each vertex, adds the above attributes.
	st.add_vertex(Vector3(-1, -1, 0));
	
	st.add_normal(Vector3(0, 0, 1));
	st.add_uv(Vector2(0, 1));
	st.add_vertex(Vector3(-1, 1, 0));
	
	st.add_normal(Vector3(0, 0, 1));
	st.add_uv(Vector2(1, 1));
	st.add_vertex(Vector3(1, 1, 0));
	
	# Create indices, indices are optional.
	st.index();
	
	# Commit to a mesh.
	var mesh = st.commit();
	
	
	
	print("generate map");
