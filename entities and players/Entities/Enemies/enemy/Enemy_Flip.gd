extends CollisionShape2D


func _on_right_collision_body_entered(body: Node2D) -> void:
	get_node(".").direction *= -1


func _on_left_collision_body_entered(body: Node2D) -> void:
	get_node(".").direction *= -1
