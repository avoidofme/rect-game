extends CharacterBody2D
@onready var dash_timer: Timer = $dash_timer
@onready var dashing_timer: Timer = $dashing_timer
@onready var jump_buffer_timer: Timer = $jump_buffer_timer

const speed = 100.0
const jump_vel = -200.0
var jump_vel_avail = jump_vel
var facing_right = true

var is_grounded = false

var is_wall_slide = false
var wall_jump_vel = -500

var is_jumping = false
var can_jump = false
var max_jump = 1
var jump_avail = max_jump

var jump_buffer = false

var is_running = false

var is_reverse = false
var can_reverse = true
var max_reverse = 2
var reverse_avail = max_reverse

var is_dashing = false
var dash_dir = null

func _process(delta: float) -> void:
	$"../Label".text = str(facing_right)

func _physics_process(delta: float) -> void:
	is_running = false
	can_reverse = true if reverse_avail > 0 else false
	
	if is_dashing: $hitbox.visible = false
	else: $hitbox.visible = true
	
	# set grounded
	if is_reverse:
		if is_on_ceiling(): is_grounded = true
		else: is_grounded = false
	else:
		if is_on_floor(): is_grounded = true
		else: is_grounded = false
	
	# if normal
	if not is_on_floor() and not is_reverse:
		velocity += get_gravity() * delta
	
	# if reverse
	if not is_on_ceiling() and is_reverse:
		velocity += -get_gravity() * delta
	
	if is_grounded:
		is_wall_slide = false
		is_jumping = false
		can_jump = true
		jump_vel_avail = jump_vel
		reverse_avail = max_reverse
	else:
		can_jump = false
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_wall_slide:
		velocity.y = -wall_jump_vel if is_reverse else  wall_jump_vel
		velocity.x = wall_jump_vel if facing_right else -wall_jump_vel
	
	if (Input.is_action_pressed("jump") or jump_buffer) and (can_jump or is_jumping):
		is_jumping = true
		can_jump = false
		if jump_vel_avail < -1:
			velocity.y += -jump_vel_avail if is_reverse else jump_vel_avail
			jump_vel_avail *= 0.7
		else:
			is_jumping = false
			velocity.y *= 0.5
		if jump_buffer:
			jump_buffer = false

	
	if Input.is_action_just_released("jump") and is_jumping:
		is_jumping = false
		if not is_reverse and velocity.y < 0:
			velocity.y *= 0.5
		elif is_reverse and velocity.y > 0:
			velocity.y *= 0.5
	
	# reverse
	if Input.is_action_just_pressed("reverse") and can_reverse:
		is_grounded = false
		reverse_avail -= 1
		is_reverse = not is_reverse

	# move
	var direction := Input.get_axis("left", "right")
	if Input.is_action_pressed("run"):
		is_running = true
	if direction:
		var old_facing_right = facing_right
		facing_right = true if direction > 0 else false
		
		var _speed = speed
		if is_running: _speed *= 2
		if not is_grounded: _speed *= 0.6
		if is_dashing: _speed = speed * 50
		
		if is_wall_slide:
			if not (old_facing_right == facing_right):
				velocity.x = direction * _speed
		else:
			velocity.x = direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	is_dashing = false
	is_wall_slide = false
	
	# wall slide, not yet
	if is_on_wall():
		is_wall_slide = true
		if velocity.y > 0.5 and not is_reverse:
			velocity.y *= 0.5
		elif velocity.y < 0.5 and is_reverse:
			velocity.y *= 0.5
	
	# apply move
	move_and_slide()

func _input(e: InputEvent) -> void:
	if e.is_action_pressed("ui_cancel"): get_tree().quit()
	
	if e.is_action_pressed("jump"):
		jump_buffer_timer.start()
		jump_buffer = true
	
	if e.is_action_pressed("left"):
		if dash_dir == "l":
			is_dashing = true
		else:
			dash_timer.start()
			dash_dir = "l"
	elif e.is_action_pressed("right"):
		if dash_dir == "r":
			is_dashing = true
		else:
			dash_timer.start()
			dash_dir = "r"


func _on_dash_timer_timeout() -> void:
	dash_dir = null


func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer = false
