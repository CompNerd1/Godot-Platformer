extends Camera2D

@onready var player = get_node("/root/Level1/Player")
@export var speed = 5

func _physics_process(delta):
	position.x = lerp(position.x,player.position.x,speed*delta)
	position.y = lerp(position.y,player.position.y,speed*delta)
