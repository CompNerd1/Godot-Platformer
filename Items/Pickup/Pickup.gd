extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		Globals.power_up = true
		$Sprite2D.visible = false
		$Timer.start()
		collision_mask = 0

func _on_timer_timeout() -> void:
	collision_mask = 1
	$Sprite2D.visible = true
