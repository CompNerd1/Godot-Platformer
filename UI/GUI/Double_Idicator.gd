extends TextEdit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_visible(Globals.power_up)
