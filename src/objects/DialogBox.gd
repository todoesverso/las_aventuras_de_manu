extends RichTextLabel

var line = 0

var dialog = ["Hola Manu!",
			"Mama y Nina salieron a pasear",
			"pero te dejaron muchos libros en el camino",
			"para que juntes y lleves hasta Andino",
			"donde te espera Papa",
			"Tene cuidado con las palomas!"]

func _ready() -> void:
	var timer = get_node("../Timer")
	timer.connect("timeout", self, "_on_Timer_timeout")
	set_visible_characters(0)

func _on_Timer_timeout():
	if line >= len(dialog):
		line = 0
		return
	
	var i_am_not_proud_about_this = "          "

	set_bbcode(dialog[line] + i_am_not_proud_about_this)
	if get_visible_characters() < len(get_bbcode()):
		set_visible_characters(get_visible_characters() + 1)
	else:
		set_visible_characters(0)
		line += 1
