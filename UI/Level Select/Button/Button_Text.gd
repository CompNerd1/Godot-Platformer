extends Label

var number: String

# Called when the node enters the scene tree for the first time.
func _ready():
	number = get_parent().number
	text = number
