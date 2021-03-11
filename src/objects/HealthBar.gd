extends TextureRect

onready var health_bar:  TextureProgress = get_node("TextureProgress")

func _ready() -> void:
    health_bar.value = 100
    
func set_percent_value_int(value: int) -> void:
    health_bar.value = value
