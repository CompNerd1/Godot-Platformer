extends CharacterBody2D

const SPEED_CONST = 3.0
const SLOW_DOWN = 300.0
const JUMP_VELOCITY = -4.0

@export var speed: int
@export var run_speed: int
@export var jump_height: int
@export var health: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var run = false

func _ready() -> void:
	Globals.health = health

func on_hit():
	velocity.x = 5000
	velocity.y = -5000

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if (velocity.y < -10):
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 2
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY * jump_height
	
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor() and Globals.power_up:
		velocity.y += JUMP_VELOCITY * jump_height
		Globals.power_up = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if run:
		if Input.is_action_just_pressed("Run"):
			run = false
	else:
		if Input.is_action_just_pressed("Run"):
			run = true
	
	if direction:
		if run:
			velocity.x += direction * SPEED_CONST * run_speed
		else:
			velocity.x += direction * SPEED_CONST * speed
		
	else:
		velocity.x += move_toward(velocity.x, 0, SLOW_DOWN)
	
	move_and_slide()
