extends Label

var num: String

# Called when the node enters the scene tree for the first time.
func _ready():
	#var label = $Label
	get_parent().number = num
	#label.text = num
	$Label.text = set_text(num)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
