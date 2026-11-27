extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var angle = atan2(-position.y, -position.x)
	var dist = sqrt(pow(position.x, 2) + pow(position.y, 2))
	if dist > 5:
		position.x += cos(angle) * 5
		position.y += sin(angle) * 5
	else:
		position = Vector2.ZERO
