class_name NameInput extends LineEdit

@export var rename_help: Node2D
@export var leaderboards: Leaderboards

func _ready() -> void:
	focus_entered.connect(input_focused)
	focus_exited.connect(change_name)
	text_changed.connect(check_name)

	await get_tree().create_timer(0.1).timeout

	if leaderboards and leaderboards.player:
		text = leaderboards.player.name
		text_changed.emit(text)
		if rename_help and text != "Anon": rename_help.hide()

func input_focused():
	await get_tree().create_timer(0.1).timeout
	select_all()
	caret_column = len(text)
	if rename_help: rename_help.hide()

func change_name():
	if text.is_empty():
		text = "Anon"
		text_changed.emit(text)
	leaderboards.change_name(text)

func check_name(content: String):
	var regex = RegEx.new()
	regex.compile("[^A-Za-z0-9]")
	text = regex.sub(content, "", true)
	caret_column = len(text)
