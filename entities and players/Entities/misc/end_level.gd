extends CollisionPolygon2D

func _on_node_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		Globals.power_up = false
		get_tree().change_scene_to_file("res://UI/Level Select/LevelSelect.tscn")
