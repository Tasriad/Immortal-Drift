extends Node

var player_scenes = {
	"player": preload("res://scenes/player.tscn"),
	"light_mage": preload("res://scenes/player_light_mage.tscn"),
	# Add other player scenes here
}
var player_current_attack = false
var current_scene = "world" # world cliff_side
var player_start_posx = 584
var player_start_posy = 670
var active_player: Node = null # To store the currently active player character
var current_player_scene = null # To hold the current player's scene

func _ready():
	# Set the initial active player
	print("global is ready.")
	# Initially load the default player scene
	active_player = player_scenes["player"].instantiate()

	# Try to find the world node only if it exists in the current scene
	var world_node = get_tree().get_root().get_node_or_null("world")
	if world_node:
		print("world node: " + world_node.name)
		print("active player: " + active_player.name)
		# Check if the active player is already present
		world_node.add_child(active_player)  # Add to the initial scene if not present
		print("Active player added: " + active_player.name)
	else:
		print("world node is null, likely in main_menu")
