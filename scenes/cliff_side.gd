extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("cliff_side ready")
	if not is_instance_valid(global.active_player):
		global.active_player = global.player_scenes["player"].instantiate() # Or instantiate the correct character
    
	global.active_player.position = Vector2(global.player_exit_cliffside_posx, global.player_exit_cliffside_posy)
	add_child(global.active_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()


func _on_world_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene=true
		



func _on_world_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene=false

func change_scene():
	if global.transition_scene:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
		global.finish_changescene()

		
		
		
		
	  		
	  		
	  		
