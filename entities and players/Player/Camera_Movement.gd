extends Camera2D

@onready var player = get_node("../Player/CharacterBody2D")
@onready var player_add = get_node("../Player")
@export var speed = 7
var screen_size = 648
var y_level
var location

func _physics_process(delta):
	location = player.position.y + player_add.position.y
	y_level = abs(location) as int / screen_size
	position.x = lerp(position.x,player.position.x+player_add.position.x,speed*delta)
	if(location > 0):
		position.y = lerp(position.y, screen_size as float / 2, speed * 2 * delta)
	else:
		position.y = lerp(position.y,-(screen_size as float / 2 + (y_level * screen_size)),speed*2*delta)
