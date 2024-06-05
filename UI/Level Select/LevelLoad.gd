extends Button

@export var level: Array[PackedScene]

func _on_pressed():
	LevelSelect.levelSelect(level)
