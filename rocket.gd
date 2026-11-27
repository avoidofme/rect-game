extends StaticBody2D


var speed = 10.0

var size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = get_viewport_rect().size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position.x += speed
	
	if position.x > size.x - size.x/2:
		position.x = -size.x/2
