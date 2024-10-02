extends TextEdit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Globals.power_up):
		visible = true
	else:
		visible = false
