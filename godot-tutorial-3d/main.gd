extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout():
	# Make sure we have a player!
	if not $Player:
		return
	
	# Create our mob scene.
	var mob = mob_scene.instantiate()
	
	var mob_spawn_loc = get_node("SpawnPath/SpawnLocation")
	mob_spawn_loc.progress_ratio = randf()
	
	var player_pos = $Player.position
	mob.initialize(mob_spawn_loc.position, player_pos)
	
	add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit():
	# Stop our mob timer since the game ended.
	$MobTimer.stop()
	
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
