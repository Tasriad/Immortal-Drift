extends Node


var player_current_attack=false
var current_scene="world" #world cliff_side
var transition_scene=false
var player_exit_cliffside_posx =205
var player_exit_cliffside_posy =16
var player_start_posx =16
var player_start_posy =20

var game_first_loadin=true


func finish_changescene():
	if transition_scene==true:
		print("Hello")
		transition_scene=false
		if current_scene=="world":
			current_scene="cliff_side"
		else:
			current_scene=="world"
	else:
		print("Bye")
		
