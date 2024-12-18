extends CharacterBody2D

const JUMP_VELOCITY = -1

@export var acceleration: float
@export var max_speed: int
@export var max_run_speed: int
@export var jump_speed: float
@export var health: int
@export var friction: float
@export var terminal_velocity: int
@export var climb_velocity: int
var jumptime = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var knockback = false
var run = false
#every frame not physics
func _process(delta: float) -> void:
	if velocity.y >= terminal_velocity * 0.75 and jumptime:
		$CharSprite.set_frame(3)
	if velocity.y < terminal_velocity * 0.75 and velocity.y >= terminal_velocity * 0.25:
		$CharSprite.set_frame(1)
	if velocity.y < terminal_velocity * 0.25:
		$CharSprite.set_frame(14)
	if velocity.y == 0:
		$CharSprite.set_frame(5)
	if velocity.x != 0:
		if run:
			$CharSprite.set_frame(7)
		else:
			$CharSprite.set_frame(6)
	else:
		$CharSprite.set_frame(5)
#start
func _ready() -> void:
	Globals.health = health
	climb_velocity *= -1
#when you are not moving and get hit
func enemy_on_hit(x_velocity: float):
	if velocity.x == 0:
		velocity.x = (abs(x_velocity) / x_velocity) * 500
		$Timer.start()
#when you are moving and get hit
func on_hit():
	if velocity.x != 0:
		velocity.x = -1 * (velocity.x / abs(velocity.x)) * 500
	velocity.y = JUMP_VELOCITY * jump_speed * 0.75
	knockback = true
	$Timer.start()
#allows you to move after getting his
func _on_timer_timeout() -> void:
	knockback = false
#every frame with physics
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_left"):
		$CharSprite.scale = Vector2(-1,1)
	if Input.is_action_just_pressed("ui_right"):
		$CharSprite.scale = Vector2(1,1)
	
	#climb
	if Globals.climb and Input.is_action_pressed("Jump"):
		velocity.y = climb_velocity
	elif Globals.climb and Input.is_action_pressed("Down"):
		velocity.y = -climb_velocity
	elif Globals.climb:
		velocity.y = 0
	
	#RUN
	if Input.is_action_just_pressed("Run"):
		run = !run
	
	#Time in air reset
	if is_on_floor():
		jumptime = false
	
	# Add the gravity.
	if not is_on_floor() and not Globals.climb:
		if(velocity.y + gravity > terminal_velocity):
			velocity.y = terminal_velocity
		if(velocity.y < terminal_velocity):
			velocity.y += gravity
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_speed
		$JumpTime.start();
	
	#Double jump
	if Input.is_action_just_pressed("Jump") and !is_on_floor() and Globals.power_up:
		velocity.y = JUMP_VELOCITY * jump_speed
		Globals.power_up = false
		$JumpTime.start();
	
	#movement
	if not knockback:
		#run
		if not run:
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
	velocity.y = 0
