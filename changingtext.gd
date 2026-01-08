extends Label3D

var texts = ["UwU", "GG", "oWo", "^_^", ">_<", "◕‿◕"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	self.text = texts.pick_random()
	pass # Replace with function body.
