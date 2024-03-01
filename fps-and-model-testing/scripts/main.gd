extends Node

@export var player: PackedScene

var fps_label : Label

func _ready():
	fps_label = get_node("/root/Main/Ui/Container/FPS/Label")

func _spawn_in_3d_world(map_name):
	# Get path to map scene.
	var map_scene_path = "res://scenes/maps/%s.tscn" % map_name
	
	# Load scene.
	var map_scene = load(map_scene_path)
	
	if not map_scene:
		print("Error loading map scene: %s" % map_scene_path)
		
		return
	
	# Init map scene.
	var map = map_scene.instantiate()
	
	# Add map scene to main project.	
	get_node("/root/Main/Map").add_child(map)
	
	# Capture mouse input now.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Load player UI.
	var ui_scene_path = "res://scenes/player/ui.tscn"
		
	var ui_scene = load(ui_scene_path)
		
	if ui_scene:
		var ui = ui_scene.instantiate()
		
		get_node("/root/Main").add_child(ui)
	else:
		print("Failed to load UI!")
		
	# Spawn player into the game.
	print("Spawning in player")
	
	var player_scene_path = "res://scenes/player/player.tscn"
	
	var ply_scene = load(player_scene_path)
	
	if not ply_scene:
		print("Failed to load player scene!")
		
		return
	
	var ply = ply_scene.instantiate()
	
	var loc = Vector3(0, 5.0, 0)
	ply.position = loc

	get_node("/root/Main").add_child(ply)
	
	# Hide menu for now.
	$Menu/SubViewportContainer/Main/MenuButton.visible = false

func _process(delta):
	if fps_label:
		fps_label.text = "FPS: %s" % Engine.get_frames_per_second()

func _on_menu_button_pressed():
	print("Loading into test1...")
	
	_spawn_in_3d_world("test1")
