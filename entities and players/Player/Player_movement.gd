extends CharacterBody2D

const JUMP_VELOCITY = -1

@export var acceleration: float
@export var max_speed: int
@export var max_run_speed: int
@export var jump_speed: float
@export var health: int
@export var friction: float
@export var terminal_velocity: int
var jumptime = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var knockback = false
var run = false

func _process(delta: float) -> void:
	if velocity.y >= terminal_velocity * 0.75 and jumptime:
		$CharSprite.set_frame(3);
	if velocity.y < terminal_velocity * 0.75 and velocity.y >= terminal_velocity * 0.25:
		$CharSprite.set_frame(1);
	if velocity.y < terminal_velocity * 0.25:
		$CharSprite.set_frame(14);
	if velocity.y == 0:
		$CharSprite.set_frame(5);

func _ready() -> void:
	Globals.health = health

func enemy_on_hit(x_velocity: float):
	if velocity.x == 0:
		velocity.x = (abs(x_velocity) / x_velocity) * 500
		$Timer.start()

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
	
	#Time in air reset
	if is_on_floor():
		jumptime = false
	
	# Add the gravity.
	if not is_on_floor():
		if(velocity.y + gravity > terminal_velocity):
			velocity.y = terminal_velocity
		if(velocity.y < terminal_velocity):
			velocity.y += gravity
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_speed
		$JumpTime.start();
	
	#Double jump
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor() and Globals.power_up:
		velocity.y = JUMP_VELOCITY * jump_speed
		Globals.power_up = false
		$JumpTime.start();
	
	#movement
	if not knockback:
		#run
		if not run or (Globals.climb and not is_on_floor()):
			if Input.is_action_pressed("ui_right"):
				velocity.x += acceleration / 2
				if velocity.x > max_speed:
					velocity.x = max_speed
			if Input.is_action_pressed("ui_left"):
				velocity.x -= acceleration / 2
				if abs(velocity.x) > max_speed:
					velocity.x = -1 * max_speed
		#not run
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

#time in air for sprite change
func _on_jump_time_timeout() -> void:
	jumptime = true

#check if you are enter a physics climb (physics layer 2) tile
func _on_area_2d_body_entered(body: Node2D) -> void:
	Globals.climb = true

#check if you are leave a physics climb (physics layer 2) tile
func _on_area_2d_body_exited(body: Node2D) -> void:
	Globals.climb = false
