extends CharacterBody2D

const JUMP_VELOCITY = -1

@export var acceleration: float
@export var max_speed: int
@export var max_run_speed: int
@export var jump_speed: float
@export var health: int
@export var friction: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var knockback = false
var run = false



func _ready() -> void:
	Globals.health = health


func on_hit():
	if velocity.x != 0:
		velocity.x = -1 * (velocity.x / abs(velocity.x)) * 500
	velocity.y = JUMP_VELOCITY * jump_speed * 0.75
	knockback = true
	$Timer.start()

func _on_timer_timeout() -> void:
	knockback = false

func _physics_process(delta):
	#RUN
	if Input.is_action_just_pressed("Run"):
		run = !run
	
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
		if !run:
			if Input.is_action_pressed("ui_right"):
				velocity.x += acceleration / 2
				if velocity.x > max_speed:
					velocity.x = max_speed
			if Input.is_action_pressed("ui_left"):
				velocity.x -= acceleration / 2
				if abs(velocity.x) > max_speed:
					velocity.x = -1 * max_speed
		else:
			if Input.is_action_pressed("ui_right"):
				velocity.x += acceleration
			if velocity.x > max_run_speed:
				velocity.x = max_run_speed
			if Input.is_action_pressed("ui_left"):
				velocity.x -= acceleration
				if abs(velocity.x) > max_run_speed:
					velocity.x = -1 * max_run_speed
	#friction
	if not Input.is_action_pressed("ui_right"):
		if not Input.is_action_pressed("ui_left"):
			if is_on_floor():
				if !run:
					if abs(velocity.x) <= abs(friction):
						velocity.x = 0
					if velocity.x > 0:
						velocity.x -= friction
					if velocity.x < 0:
						velocity.x += friction
				else:
					if abs(velocity.x) <= abs(friction * 2.5):
						velocity.x = 0
					if velocity.x > 0:
						velocity.x -= friction * 2.5
					if velocity.x < 0:
						velocity.x += friction * 2.5
			else:
				if abs(velocity.x) <= friction / 1.25:
					velocity.x = 0 
				if velocity.x > 0:
					velocity.x -= friction / 1.125
				if velocity.x < 0:
					velocity.x += friction / 1.125
	
	move_and_slide()
