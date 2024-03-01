extends Node

@export var player: PackedScene

var fps_label : Label

func _ready():
	# Capture mouse.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Spawn player into the game.
	print("Spawning in player")
	var ply = player.instantiate()
	
	var loc = Vector3(0, 5.0, 0)
	ply.position = loc
	
	add_child(ply)
	
	fps_label = get_node("/root/Main/UI/FPS_Port/Label")

func _process(delta):
	if fps_label:
		fps_label.text = "FPS: %s" % Engine.get_frames_per_second()
