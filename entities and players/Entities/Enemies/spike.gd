extends CollisionPolygon2D

<<<<<<< HEAD
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_spike_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		body.on_hit()
		Globals.health -= 10
=======
func _on_spike_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		Globals.health -= 10
		body.on_hit()
>>>>>>> eb92f52090125bec3f96d4b1aa4010c599a6bd70
