extends Camera2D

@onready var player = get_node("../Player/CharacterBody2D")
@onready var player_add = get_node("../Player")
@export var speed = 7
var screen_size = 648
var y_level
var location

func _physics_process(delta):
	location = player.position.y + player_add.position.y
	position.x = lerp(position.x,player.position.x+player_add.position.x,speed*delta)
	position.y = screen_size / 2
