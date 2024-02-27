extends Node

@export var mob_scene: PackedScene

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_loc = get_node("SpawnPath/SpawnLocation")
	mob_spawn_loc.progress_ratio = randf()
	
	var player_pos = $Player.position
	mob.initialize(mob_spawn_loc.position, player_pos)
	
	add_child(mob)
