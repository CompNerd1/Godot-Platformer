extends TextEdit

var health
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health = Globals.health
	text = str(health)
