extends Panel


export var books_collected = 0

onready var books_label = $Label2

func missing_books():
	return get_total_books() - books_collected

func get_total_books():
	var books_node = get_node("/root/Game/Level/Libros").get_children()

	var count = 0

	if books_node:
		for i in books_node:
			count += 1

	return count

func _ready():
	books_label.set_text(str(books_collected))
	# Static types are necessary here to avoid warnings.
	# Check if the game is in splitscreen mode by checking the scene root name.
	var _player_path = get_parent().get_parent()
	_player_path.connect("collect_book", self, "_collect")


func _collect():
	books_collected += 1
	books_label.set_text(str(books_collected))
