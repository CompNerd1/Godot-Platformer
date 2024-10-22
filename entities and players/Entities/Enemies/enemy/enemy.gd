extends CharacterBody2D
@export var speed: int
var direction = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x = speed * direction

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		body.on_hit()
		Globals.health -= 10
