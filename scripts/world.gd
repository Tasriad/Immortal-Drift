extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("world ready")
	if global.game_first_loadin == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()
	handle_player_input(delta)  # Handle input based on the active player	
	
func handle_player_input(delta):
	if global.active_player != null:
		if is_instance_valid(global.active_player):  # Check if the active player is still valid
			global.active_player.handle_input(delta)
		else:
			print("Active player has been freed")


func _on_cliffside_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("transition point entered")
		global.transition_scene=true


func _on_cliffside_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		print("transition point exited")
		global.transition_scene=false
		
		
func change_scene():
	if global.transition_scene==true:
		print("changing scene (in world)")
		get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
		global.game_first_loadin=false
		global.finish_changescene()
	
