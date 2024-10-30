extends CollisionPolygon2D

func _on_pickup_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		Globals.power_up = true
		queue_free()
