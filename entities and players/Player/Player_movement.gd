extends CharacterBody2D


const SPEED_CONST = 3.0
const SLOW_DOWN = 300.0
const JUMP_VELOCITY = -4.0

@export var speed: int
@export var run_speed: int
@export var jump_height: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_height

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	var run = false
	if run:
		var run = Input.is_action_just_pressed("Run")
	
	if direction:
		velocity.x = direction * SPEED_CONST * speed
	else:
		velocity.x = move_toward(velocity.x, 0, SLOW_DOWN)

	move_and_slide()
