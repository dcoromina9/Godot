extends Node

export (PackedScene) var Mob
export (PackedScene) var Mob2
var score
var random

func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	random = randi()%11+1
	var mob = Mob.instance()
	var mob2 = Mob2.instance()
	if random <= 8:
		add_child(mob)
		score += 1
	elif random >= 10 :
		add_child(mob2)
		score += 2
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	mob2.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob2.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	mob2.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob2.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")
	$HUD.connect("start_game", mob2, "_on_start_game")
