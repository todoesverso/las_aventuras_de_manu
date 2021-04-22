extends Actor

var pidgeons: Array = ['p1', 'p2', 'p3']
onready var anim_player:  AnimationPlayer = get_node("Sprite/AnimationPlayer")
var hit_manu: bool = false

func _ready() -> void:
	speed = Vector2(40.0, 100.0)
	gravity = 10.0
	$AudioStreamPlayer2D.play()
	set_physics_process(false)
	_velocity.x = -speed.x
	anim_player.play(pidgeons[randi() % pidgeons.size()])

func _on_HitPlayer_body_entered(body: Node) -> void:
	if body.name == "Manu":
		$Sprite.scale.x *= -1
		_velocity = calculate_stomp_velocity(_velocity, 30)
		hit_manu = true

func _on_HitPlayer_body_exited(body: Node) -> void:
	if body.name == "Manu":
		hit_manu = false

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body and body.global_position.y > get_node("StompDetector").global_position.y:
		return
	die()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	die()

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall() and not hit_manu:
		_velocity.x *= -1.0
		$Sprite.scale.x *= -1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y =  -impulse
	out.x = -impulse
	return out

func die() -> void:
	get_node("CollisionShape2D").disabled = true
	queue_free()
