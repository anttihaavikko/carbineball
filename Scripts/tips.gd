extends Node

@export var title: RichTextLabel
@export var heading: RichTextLabel
@export var image: TextureRect
@export var description: RichTextLabel
@export var images: Array[Texture2D]

var tip_titles = [
	"TIPS",
	"MULTIPLIER",
	"THE SUN",
	"CAROUSEL",
	"MULTI BALL",
	"BONUS GAME",
	"SUNNY BUMPERS",
	"TILT",
	"GOOD LUCK"
]

var tips = [
	"You can find some tips on how to score well here. You should probably play at least a round first so there is some context.",
	"Increase multiplier continuously by bumping the ball then shooting it before bumping again.",
	"Letting the ball bounce on the sun also increases the multiplier and the sun also helps keeping the ball in air. Just keep your character at enough of a distance from it as touching it will reset your multiplier.",
	"Rotate the carousel with side buttons. The bumper in the middle increments the bottom right bumper value by one and they all score based on the total of three values multiplied together.",
	"Activate safety launchers by toggling on all three buttons. Then you can activate the ball lock with them and the sun. Release all locked balls with the bottom corner buttons and enjoy the madness.",
	"Every 30 seconds, a bonus game changes and is indicated in the center of the screen. That indicated section of the board scores for way more points so focus on that.",
	"This bonus game increases the multiplier addition for bumping the sun in addition to increasing the side bumper scoring. Good way to get the multiplier up fast.",
	"If the ball touches just the same two objects constantly enough times, the board will tilt. It'll display a warning first so better act on it any way you can or you'll lose your ball.",
	"That's it, I guess. There would be more details of course but the deadline is slowly creeping up on me.\n\nHope you enjoy the game! <3"
]

var page := 0

func _ready() -> void:
	change(0)

func next():
	change(1)

func prev():
	change(-1)

func change(dir: int):
	page += dir
	if page < 0: page = tips.size() - 1
	if page >= tips.size(): page = 0
	title.text = "PAGE %d/%d" % [page + 1, tips.size()]
	heading.text = tip_titles[page]
	description.text = tips[page]
	image.texture = images[page]
