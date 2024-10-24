extends CharacterBody2D
@export var speed: int
var direction = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x = speed * direction
	velocity.y = 100
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		body.on_hit()
		Globals.health -= 10


func _on_right_collision_body_entered(body: Node2D) -> void:
	get_node(".").direction *= -1


func _on_left_collision_body_entered(body: Node2D) -> void:
	get_node(".").direction *= -1
