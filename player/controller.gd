# Adjust speeds to realistic values
# TODO State management

# TODO Features
# * Jumping
# * Crouching
# * Crawling
# * Leaning
# * Shoulder look
# * Going up / sliding down ramps
# * Walking stairs
# * Climbing ladders

extends KinematicBody

# TODO Centralized position
const GRAVITY := Vector3(0,-9.8,0) # TODO Use project setting
const MOUSE_SPEED := 5.0

onready var camera := $Camera

const SPEED_WALKING := 6.0
const ACCELERATION_WALKING := 1.0
const SPEED_RUNNING := SPEED_WALKING * 3.0
const ACCELERATION_RUNNING := 1.0

var velocity := Vector3(0,0,0)
var acceleration := GRAVITY
var jumping := false

func _physics_process(delta):
	if is_on_floor(): 
		velocity = calculate_movement_velocity()
	
	velocity += acceleration * delta
	move_and_slide(velocity, Vector3.UP)

func calculate_movement_velocity() -> Vector3:
	var velocity := Vector3(0,0,0)
	
	if Input.is_action_pressed("move_forward"):
		velocity.z = -1
	elif Input.is_action_pressed("move_backward"):
		velocity.z = 1
	else:
		velocity.z = 0
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	elif Input.is_action_pressed("move_right"):
		velocity.x = 1
	else:
		velocity.x = 0
	
	var speed : float = SPEED_WALKING if not Input.is_action_pressed("run") else SPEED_RUNNING
	velocity = velocity.normalized() * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y) # Match facing direction
	
	return velocity

func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		camera_movement(event)

func camera_movement(event : InputEventMouseMotion):
	var mod := MOUSE_SPEED * get_process_delta_time()
	
	# Rotate body horizontally
	rotate_y(-deg2rad(event.relative.x) * mod)
	
	# Rotate camera vertically
	camera.rotate_x(-deg2rad(event.relative.y) * mod)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)