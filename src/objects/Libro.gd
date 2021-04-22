extends Area2D

onready var anim_player:  AnimationPlayer = $AnimationPlayer

func _ready():
	$libro.frame = randi() % 23

func _on_body_entered(body: Node) -> void:
	$AudioGrab.connect("finished", self, "queue_free")
	$AudioGrab.play()
	anim_player.play("fade_out")
	body.emit_signal("collect_book")


