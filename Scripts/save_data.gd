class_name SaveData extends Object

var character := 0
var ball := 0
var characters := [true]
var balls := [true]

static func load() -> SaveData:
	return Saver.new().load(func(): return SaveData.new()) as SaveData

func save():
	Saver.new().save(self)

func has_char(p: Dude.Personality) -> bool:
	return characters.size() > p and characters[p]

func unlock_char(p: Dude.Personality):
	if characters.size() < p + 1: characters.resize(p + 1)

func has_ball(p: Ball.Personality) -> bool:
	return balls.size() > p and balls[p]

func unlock_ball(p: Ball.Personality):
	if balls.size() < p + 1: balls.resize(p + 1)
