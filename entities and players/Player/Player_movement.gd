extends CharacterBody2D

const JUMP_VELOCITY = -4.0

@export var acceleration: int
@export var run_acceleration: int
@export var max_speed: int
@export var max_run_speed: int
@export var jump_speed: int
@export var health: int
@export var friction: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var knockback = false
var run = false

var timer = Timer.new()

func _ready() -> void:
	Globals.health = health

func on_hit():
	velocity.x = -1 * (velocity.x / abs(velocity.x)) * 500
	velocity.y = JUMP_VELOCITY * jump_speed * 0.
	knockback = true
	timer.start(1.5)

func _on_timer_timeout() -> void:
	knockback = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_speed
	
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor() and Globals.power_up:
		velocity.y = JUMP_VELOCITY * jump_speed
		Globals.power_up = false
	
	#movement
	if not knockback:
		if Input.is_action_pressed("ui_right"):
			velocity.x += acceleration
			if velocity.x > max_speed:
				velocity.x = max_speed
		if Input.is_action_pressed("ui_left"):
			velocity.x -= acceleration
			if abs(velocity.x) > max_speed:
				velocity.x = -1 * max_speed
			
	if not Input.is_action_pressed("ui_right"):
		if not Input.is_action_pressed("ui_left"):
			if abs(velocity.x) < friction:
				velocity.x = 0
			if is_on_floor():
				if velocity.x > 0:
					velocity.x -= friction
				if velocity.x < 0:
					velocity.x += friction
			else:
				if velocity.x > 0:
					velocity.x -= friction / 1.25
				if velocity.x < 0:
					velocity.x += friction / 1.25
	
	move_and_slide()
