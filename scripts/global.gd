extends Node


var player_current_attack=false
var current_scene="world" #world cliff_side
var transition_scene=false
var player_exit_cliffside_posx =0
var player_exit_cliffside_posy =0
var player_start_posx =0
var player_start_posy =0
var active_player: Node = null  # To store the currently active player character

func _ready():
	# Set the initial active player
	active_player = get_tree().get_root().get_node("world/player")  # Adjust the path as necessary

func finish_changescene():
	if transition_scene==true:
		transition_scene=false
		if current_scene=="world":
			current_scene="cliff_side"
		else:
			current_scene=="world"
