extends Camera2D

@onready var player = get_node("../Player/CharacterBody2D")
@onready var player_add = get_node("../Player")
@export var speed = 7

func _physics_process(delta):
	position.x = lerp(position.x,player.position.x+player_add.position.x,speed*delta)
	position.y = 324
