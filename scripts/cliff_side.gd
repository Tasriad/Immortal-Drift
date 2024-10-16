extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check and instantiate the current active player dynamically
	instantiate_active_player()
	if global.game_first_loadin == true:
		global.active_player.position = Vector2(global.player_start_posx, global.player_start_posy)
	else:
		global.active_player.position = Vector2(global.player_exit_posx, global.player_exit_posy)

# Dynamically instantiate the current active player
func instantiate_active_player() -> void:
	if global.current_character_scene == null:  # Check if no character has been set
		global.current_character_scene = global.player_scene  # Default to main player scene
	
	global.active_player = global.current_character_scene.instance()  # Instantiate the active character
	add_child(global.active_player)  # Add the player to the current scene

	# Set the player camera, physics, and other initial setups if required here.

	print("Player instantiated: ", global.active_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()
	handle_player_input(delta)


func _on_world_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene=true
		

func handle_player_input(delta):
	if global.active_player != null:
		if is_instance_valid(global.active_player):  # Check if the active player is still valid
			global.active_player.handle_input(delta)
		else:
			print("Active player has been freed")


func _on_world_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene=false
		
# Handle scene changes and cleanup
func change_scene():
	if global.transition_scene == true:
		# Remove active player before changing the scene
		global.remove_active_player()

		get_tree().change_scene_to_file("res://scenes/world.tscn")  # Or any other scene

		global.game_first_loadin = false
		global.finish_changescene()  # Finalize scene change
