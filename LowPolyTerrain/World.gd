extends Spatial

export var spawnRate = 1

export var noisePeriod = 80
export var noiseOctave = 6
export var planeMeshSize = Vector2(400, 400)
export var planeMeshSubdivideDepth = 200
export var planeMeshSubdivideWidth = 200
export var vertexAmplitude = 60

export var cameraSpeed = 1
export var movementMultiplier = 5

var maxVertexHeight = 0

func _ready():
	var noise = OpenSimplexNoise.new()
	noise.period = noisePeriod
	noise.octaves = noiseOctave
	
	var planeMesh = PlaneMesh.new()
	planeMesh.size = planeMeshSize
	planeMesh.subdivide_depth = planeMeshSubdivideDepth
	planeMesh.subdivide_width = planeMeshSubdivideWidth
	
	var surfaceTool = SurfaceTool.new()
	surfaceTool.create_from(planeMesh, 0)
	
	var arrayPlane = surfaceTool.commit()
	
	var dataTool = MeshDataTool.new()
	dataTool.create_from_surface(arrayPlane, 0)
	
	for i in range(dataTool.get_vertex_count()):
		var vertex = dataTool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * vertexAmplitude
		maxVertexHeight = max(maxVertexHeight, vertex.y)
		dataTool.set_vertex(i, vertex)
	
	for i in range(arrayPlane.get_surface_count()):
		arrayPlane.surface_remove(i)
	
	dataTool.commit_to_surface(arrayPlane)
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surfaceTool.create_from(arrayPlane, 0)
	surfaceTool.generate_normals()
	
	var meshInstance = MeshInstance.new()
	meshInstance.mesh = surfaceTool.commit()
	meshInstance.set_surface_material(0, load("res://terrain.material"))
	
	meshInstance.create_trimesh_collision()
	
	add_child(meshInstance)
	

var simpleCounter = 0

func _process(delta):
	var camAngle = $Rotate.rotation_degrees.y
	if Input.is_action_pressed("ui_accept"):
		$Rotate.rotation_degrees.y = 0
		camAngle = 0
	
	var rotateValue = 0
	if Input.is_action_pressed("ui_pan_right"):
		rotateValue += 50
	if Input.is_action_pressed("ui_pan_left"):
		rotateValue -= 50
	if Input.is_action_pressed("ui_pan_right_fast"):
		rotateValue += 100
	if Input.is_action_pressed("ui_pan_left_fast"):
		rotateValue -= 100
	$Rotate.rotation_degrees.y = camAngle + (delta * rotateValue)
	
	# Might have changed the angle, lets update the value
	camAngle = $Rotate.rotation_degrees.y
	var camPos = $Rotate/Camera.translation
	if Input.is_action_pressed("ui_zoom_in") && camPos.y > 10:
		$Rotate/Camera.translate(Vector3(0, delta * -50, delta * -50))
	if Input.is_action_pressed("ui_zoom_out") && camPos.y < 100:
		$Rotate/Camera.translate(Vector3(0, delta * 50, delta * 50))
	
	if Input.is_action_pressed("ui_right"):
		$Rotate.translate(Vector3(cos(camAngle) * delta * cameraSpeed, 0, sin(camAngle) * delta * cameraSpeed))
	if Input.is_action_pressed("ui_left"):
		$Rotate.translate(Vector3(-cos(camAngle) * delta * cameraSpeed, 0, -sin(camAngle) * delta * cameraSpeed))
	if Input.is_action_pressed("ui_up"):
		$Rotate.translate(Vector3(-sin(camAngle) * delta * cameraSpeed, 0, -cos(camAngle) * delta * cameraSpeed))
	if Input.is_action_pressed("ui_down"):
		$Rotate.translate(Vector3(sin(camAngle) * delta * cameraSpeed, 0, cos(camAngle) * delta * cameraSpeed))
