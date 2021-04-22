extends Actor

onready var anim_player:  AnimationPlayer = get_node("Sprite/AnimationPlayer")
onready var health_bar:  TextureRect = get_node("CanvasLayer/HealthBar")
onready var books = get_node("/root/Game/Level/Manu/CanvasLayer/Counter")
onready var camera = get_node("./Camera2D")
onready var sprite = $Sprite
export var stomp_impulse: = 100.0
export var hitpoints: int = 100
export var hit_costs: int = 10
var max_hitpoints: int = hitpoints

var facing_right: bool = true
var hurt: bool = false

# warning-ignore:unused_signal
signal collect_book()

func _ready() -> void:
	$Music.play()


func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "hurt":
		hurt = false

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	hurt = true
	$AudioStomp.play()
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
	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1
	animate()


func get_direction() -> Vector2:
	if Input.is_action_just_pressed("jump"):
		$AudioJump.play()
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
	if direction.y != 0.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y *= 0.6
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y =  -impulse
	return out

func animate() -> void:
	if hurt:
		anim_player.play("hurt")
		return

	var animation_new = ""

	if is_on_floor():
		animation_new = "walk" if abs(_velocity.x) > 0.1 else "idle"
	else:
		animation_new = "falling" if _velocity.y > 0 else "jumping"

	if books.get_total_books() == 0 and is_on_andino():
		animation_new = "win"

	if animation_new != anim_player.current_animation:
		anim_player.play(animation_new)

func is_on_andino():
	if 	camera.limit_right - camera.get_camera_position().x < 150:
		return true
	return false
