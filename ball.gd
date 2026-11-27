extends RigidBody2D
@onready var respawn_timer: Timer = $respawn_timer

var should_respawn = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Label2".text = str(position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if should_respawn:
		state.transform.origin = Vector2(0,0)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		should_respawn = false

func _on_respawn_timer_timeout() -> void:
	should_respawn = true
