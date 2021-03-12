extends Actor

onready var anim_player:  AnimationPlayer = get_node("Sprite/AnimationPlayer")
onready var health_bar:  TextureRect = get_node("CanvasLayer/HealthBar")
export var stomp_impulse: = 200.0
export var hitpoints: int = 100
export var hit_costs: int = 10
var max_hitpoints: int = hitpoints


var facing_right: bool = true 
var hurt: bool = false

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "hurt":
		hurt = false


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	hurt = true
	hitpoints -= hit_costs
	health_bar.set_percent_value_int(float(hitpoints)/max_hitpoints * 100)
	if hitpoints <= 0:
		die()

func die() -> void:
	pass

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0 
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	animate(_velocity)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
		)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
		
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2: 
	var out: = linear_velocity
	out.y =  -impulse
	return out

func animate(direction: Vector2) -> void:
	if hurt:
		anim_player.play("hurt")
		return
	
	if direction.x < 0:
		anim_player.play("walk_left")
		facing_right = false
	
	if direction.x > 0:
		anim_player.play("walk_right")
		facing_right = true
		
	if facing_right:
		if direction.y < 0:
			anim_player.play("jump_down_right")

		if direction.y > 0:
			anim_player.play("jump_up_right")
	else:
		if direction.y < 0:
			anim_player.play("jump_down_left")

		if direction.y > 0:
			anim_player.play("jump_up_left") 

	
	if direction.x == 0 and direction.y == 0:
		if facing_right:
			anim_player.play("idle_right")
		else:
			anim_player.play("idle_left")





