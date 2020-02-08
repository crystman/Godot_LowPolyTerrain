extends Spatial

export var cameraSpeed = 20
export var movementMultiplier = 3

export var maxX = 10
export var minX = -10
export var maxY = 10
export var minY = -10
export var maxZ = 10
export var minZ = -10

func _ready():
	pass # Replace with function body.

func _process(delta):
	# Rotation Presets
	var camAngle = $Translate/Rotate.rotation_degrees.y
	if Input.is_action_just_pressed("ui_refresh"):
		if camAngle == 0:
			$Translate/Rotate.rotation_degrees.y = 90
			camAngle = 90
		elif camAngle == 90:
			$Translate/Rotate.rotation_degrees.y = 180
			camAngle = 180
		elif camAngle == 180:
			$Translate/Rotate.rotation_degrees.y = 270
			camAngle = 270
		else:
			$Translate/Rotate.rotation_degrees.y = 0
			camAngle = 0
	
	# Rotate
	var rotateValue = 0
	if Input.is_action_pressed("ui_pan_right"):
		if Input.is_action_pressed("ui_shift"):
			rotateValue += 100
		else:
			rotateValue += 50
	if Input.is_action_pressed("ui_pan_left"):
		if Input.is_action_pressed("ui_shift"):
			rotateValue -= 100
		else:
			rotateValue -= 50
	$Translate/Rotate.rotation_degrees.y = camAngle + (delta * rotateValue)
	
	# Zoom
	camAngle = $Translate/Rotate.rotation_degrees.y
	var camPos = $Translate/Rotate/Camera.translation
	if Input.is_action_pressed("ui_zoom_in") && camPos.y > 10:
		$Translate/Rotate/Camera.translate(Vector3(0, delta * -50, delta * -50))
	if Input.is_action_pressed("ui_zoom_out") && camPos.y < 100:
		$Translate/Rotate/Camera.translate(Vector3(0, delta * 50, delta * 50))
	
	# Movement
	var vectorTranslate = Vector3(0, 0, 0)
	if Input.is_action_pressed("ui_up"):
		if Input.is_action_pressed("ui_shift"):
			vectorTranslate.x += (-sin(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
			vectorTranslate.z += (-cos(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
		else:
			vectorTranslate.x += (-sin(deg2rad(camAngle)) * delta * cameraSpeed)
			vectorTranslate.z += (-cos(deg2rad(camAngle)) * delta * cameraSpeed)
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_shift"):
			vectorTranslate.x += (sin(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
			vectorTranslate.z += (cos(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
		else:
			vectorTranslate.x += (sin(deg2rad(camAngle)) * delta * cameraSpeed)
			vectorTranslate.z += (cos(deg2rad(camAngle)) * delta * cameraSpeed)
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_shift"):
			vectorTranslate.x += (-cos(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
			vectorTranslate.z += (sin(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
		else:
			vectorTranslate.x += (-cos(deg2rad(camAngle)) * delta * cameraSpeed)
			vectorTranslate.z += (sin(deg2rad(camAngle)) * delta * cameraSpeed)
	if Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_shift"):
			vectorTranslate.x += (cos(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
			vectorTranslate.z += (-sin(deg2rad(camAngle)) * delta * cameraSpeed * movementMultiplier)
		else:
			vectorTranslate.x += (cos(deg2rad(camAngle)) * delta * cameraSpeed)
			vectorTranslate.z += (-sin(deg2rad(camAngle)) * delta * cameraSpeed)
	$Translate.translate(vectorTranslate)
	
	# Get height from position
	var position = $Translate.translation
	var MoveTo = position
	
	var terrain = get_node("/root/World/Terrain")
	var height = terrain.get_coord_height(position.x, position.z)
	MoveTo.y = height
	
	# Check in bounds
	if position.x > maxX:
		MoveTo.x = maxX
	elif position.x < minX:
		MoveTo.x = minX
	if position.y > maxY:
		MoveTo.y = maxY
	elif position.y < minY:
		MoveTo.y = minY
	if position.z > maxZ:
		MoveTo.z = maxZ
	elif position.z < minZ:
		MoveTo.z = minZ
	
	if MoveTo != position:
		$Translate.translation = MoveTo

func position():
	return $Translate.translation
