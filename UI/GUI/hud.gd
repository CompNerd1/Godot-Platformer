extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ded.visible = false
	$TextEdit2.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.health == 0:
		$Ded.visible = true
		$"Double Jump".visible = false
		$TextEdit2.visible = false

func _on_button_pressed() -> void:
	Globals.power_up = false
	get_tree().change_scene_to_file("res://UI/Level Select/LevelSelect.tscn")
