class_name MainMenu
extends Control

@onready var start_button=$MarginContainer/HBoxContainer/VBoxContainer/Start_game as Button
@onready var exit_button=$MarginContainer/HBoxContainer/VBoxContainer/Exit_game as Button
@onready  var start_level=preload("res://scenes/world.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
func on_exit_pressed() -> void:
	get_tree().quit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		print("right pressed")
