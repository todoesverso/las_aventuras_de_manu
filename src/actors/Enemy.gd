extends Actor

var hit_manu: bool = false

func _ready() -> void:
    gravity = 10.0    
    set_physics_process(false)
    _velocity.x = -speed.x

func _on_HitPlayer_body_entered(body: Node) -> void:
    if body.name == "Manu":
        _velocity = calculate_stomp_velocity(_velocity, 30)
        hit_manu = true

func _on_HitPlayer_body_exited(body: Node) -> void:
    if body.name == "Manu":
        hit_manu = false

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
    if body and body.global_position.y > get_node("StompDetector").global_position.y:
        return
    get_node("CollisionShape2D").disabled = true	
    queue_free() 

func _on_VisibilityEnabler2D_screen_exited() -> void:
    get_node("CollisionShape2D").disabled = true	
    queue_free()

func _physics_process(delta: float) -> void:
    _velocity.y += gravity * delta
    if is_on_wall() and not hit_manu:
        _velocity.x *= -1.0
    _velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2: 
    var out: = linear_velocity
    out.y =  -impulse
    out.x = -impulse
    return out






