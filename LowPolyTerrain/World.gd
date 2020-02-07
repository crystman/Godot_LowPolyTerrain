extends Spatial

export var spawnRate = 1

export var cameraSpeed = 20
export var movementMultiplier = 3

func _ready():
	pass

func _process(delta):
	# Rotation Presets
	var camAngle = $Translate/Rotate.rotation_degrees.y
	if Input.is_action_just_pressed("ui_accept"):
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
	
	# Update HUD message
#	var printString = "CamAngle: %s sin(camAngle): %s cos(camAngle): %s"
#	$HUD.update_text(printString % [camAngle, sin(deg2rad(camAngle)), cos(deg2rad(camAngle))])
	
	# Get current location
	
