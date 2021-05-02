extends RichTextLabel

onready var books = get_node("/root/Game/Level/Manu/CanvasLayer/Counter")
onready var dialog_success = [
	"Felicitaciones Manu llegaste!!!",
	"Ahora tenes un monton de libros nuevos",
	"para leer!!"
	]

onready var dialog_missing = [
	"Llegaste!!!",
	"Pero todavia te faltan libros de juntar",
	"Fijate si podes encontrar los que faltan",
	"Y volve a Andino"
	]

onready var timer = get_node("../Timer")
var not_proud = "          "
var line = 0

func _ready() -> void:
	set_bbcode(dialog_success[line])
	get_parent().visible = false
	set_visible_characters(0)
	timer.connect("timeout", self, "_on_Timer_timeout")

func _on_Timer_timeout():
	if books.get_total_books() == 0:
		if line >= len(dialog_success):
			line = 0
			return
		set_bbcode(dialog_success[line] + not_proud)

	if books.get_total_books() != 0:
		if line >= len(dialog_missing):
			line = 0
			return
		set_bbcode(dialog_missing[line] + not_proud)

	if get_visible_characters() < len(get_bbcode()):
		set_visible_characters(get_visible_characters() + 1)
	else:
		set_visible_characters(0)
		line += 1


func _on_VisibilityNotifier2D_viewport_entered(_viewport):
	get_parent().visible = true
	timer.start()
	if books.get_total_books() == 0:
		set_bbcode(dialog_success[line] + not_proud)
	else:
		set_bbcode(dialog_missing[line] + not_proud)

func _on_VisibilityNotifier2D_screen_exited():
	line = 0
	set_visible_characters(0)
	timer.stop()
	get_parent().visible = false
