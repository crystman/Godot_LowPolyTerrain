extends Spatial

export var noisePeriod = 80
export var noiseOctave = 6
export var planeMeshSize = Vector2(100, 100)
export var planeMeshSubdivideDepth = 99
export var planeMeshSubdivideWidth = 99
export var vertexAmplitude = 60

var maxVertexHeight = 0
var dataTool

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
	
	dataTool = MeshDataTool.new()
	dataTool.create_from_surface(arrayPlane, 0)
	
	for i in range(dataTool.get_vertex_count()):
		var vertex = dataTool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * vertexAmplitude
		maxVertexHeight = max(maxVertexHeight, vertex.y)
		dataTool.set_vertex(i, vertex)
#		vertex = dataTool.get_vertex(i)
#		var message = "Vertex %s: %s %s %s"
#		if vertex.z == 50 and (vertex.x > -10 and vertex.x < 10):
#			print(message % [i, vertex.x, vertex.y, vertex.z])
	
	for i in range(arrayPlane.get_surface_count()):
		arrayPlane.surface_remove(i)
	
	dataTool.commit_to_surface(arrayPlane)
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surfaceTool.create_from(arrayPlane, 0)
	surfaceTool.generate_normals()
	
	$MeshInstance.mesh = surfaceTool.commit()
	$MeshInstance.set_surface_material(0, load("res://terrain.material"))
	
	$MeshInstance.create_trimesh_collision()
	
func get_coord_height(x, z):
	var message = "coordinates to get height for: %s %s"
	print(message % [x, z])
	for i in range(dataTool.get_vertex_count()):
		var vertex = dataTool.get_vertex(i)
		if x == vertex.x & z == vertex.z:
			return vertex.y
	return 0.0
