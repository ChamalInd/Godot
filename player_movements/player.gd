extends CharacterBody3D

var direction = Vector3.ZERO
var target_velcoty = Vector3.ZERO
var speed = 5.0
var sprint_speed = 8.0
var current_speed = speed
var gravity = 20.0
var acceleration = 10.0
var mouse_sensitivity = 0.002

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		$Camera3D.rotation.x -= event.relative.y * mouse_sensitivity
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-40), deg_to_rad(40))
		
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	direction = Vector3.ZERO
	current_speed = speed
	
	if Input.is_action_pressed("move_forward"):
		direction += transform.basis * Vector3(0, 0, -1)
		
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis * Vector3(0, 0, 1)
		
	if Input.is_action_pressed("move_left"):
		direction += transform.basis * Vector3(-1, 0, 0)
		
	if Input.is_action_pressed("move_right"):
		direction += transform.basis * Vector3(1, 0, 0)	
		
	if direction != Vector3.ZERO and Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	
	target_velcoty = direction.normalized() * current_speed
	velocity.x = move_toward(velocity.x, target_velcoty.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velcoty.z, acceleration * delta)	
	
	if is_on_floor():
		velocity.y = -1
	else:
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 8.0
	
	move_and_slide()
