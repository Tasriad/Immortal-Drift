extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure the player is added to the current scene
	add_child(global.active_player)	

	print("world ready")
	$player.position.x = global.player_start_posx
	$player.position.y = global.player_start_posy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_player_input(delta)  # Handle input based on the active player	
	
func handle_player_input(delta):
	if global.active_player != null:
		if is_instance_valid(global.active_player):  # Check if the active player is still valid
			global.active_player.handle_input(delta)
		else:
			print("Active player has been freed")



		
		


	
