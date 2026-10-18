extends Node

@export var char_name_label: RichTextLabel
@export var char_desc_label: RichTextLabel
@export var ball_name_label: RichTextLabel
@export var ball_desc_label: RichTextLabel
@export var char_lock: Control
@export var ball_lock: Control
@export var dude_wrap: Wrapper
@export var ball: Ball
@export var sun: Sunny

var cur_char = Dude.Personality.Vanillad
var cur_ball = Ball.Personality.Broll

func _ready() -> void:
	show_selections()

func show_selections():
	char_lock.visible = randf() < 0.5
	ball_lock.visible = randf() < 0.5
	char_name_label.text = Dude.get_title(cur_char)
	char_desc_label.text = Dude.get_desc(cur_char, char_lock.visible)
	ball_name_label.text = Ball.get_title(cur_ball)
	ball_desc_label.text = Ball.get_desc(cur_ball, ball_lock.visible)
	dude_wrap.dude.use(cur_char)

func next_char():
	change_char(1)

func prev_char():
	change_char(-1)

func change_char(dir: int):
	var s = Dude.Personality.size()
	cur_char = ((cur_char + dir) + s) % s as Dude.Personality
	show_selections()

func next_ball():
	change_ball(1)

func prev_ball():
	change_ball(-1)

func change_ball(dir: int):
	var s = Ball.Personality.size()
	cur_ball = ((cur_ball + dir) + s) % s as Ball.Personality
	show_selections()
