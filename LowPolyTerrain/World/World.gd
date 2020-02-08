extends Spatial

export var spawnRate = 1

func _ready():
	var size = $Terrain.planeMeshSize
	var sizeX = size.x/2
	var sizeZ = size.y/2
	
	$Player.maxX = sizeX
	$Player.minX = -sizeX
	$Player.maxY = $Terrain.maxVertexHeight
	$Player.minY = $Terrain.minVertexHeight
	$Player.maxZ = sizeZ
	$Player.minZ = -sizeZ

func _process(delta):
	# Reset Ball Location
	if Input.is_action_just_pressed("ui_accept"):
		var playerLocation = $Player.position()
		playerLocation.y += 50
#		$RigidBody.linear_velocity = Vector3.ZERO
#		$RigidBody.translation = playerLocation
		
	
	# Update HUD message
	var printString = "Player Position: %s %s %s"
	var pos = $Player.position()
	$HUD.update_text(printString % [stepify(pos.x,0.1), stepify(pos.y, 0.1), stepify(pos.z, 0.1)])
#	var printString = "CamAngle: %s sin(camAngle): %s cos(camAngle): %s"
#	$HUD.update_text(printString % [camAngle, sin(deg2rad(camAngle)), cos(deg2rad(camAngle))])
