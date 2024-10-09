extends CollisionPolygon2D

func _on_spike_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		Globals.health -= 10
		body.on_hit()
