class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_game as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_game as Button
@onready var start_level = preload("res://scenes/world.tscn") as PackedScene
@onready var help_menu = $Help as HelpMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var help_button = $MarginContainer/HBoxContainer/VBoxContainer/Help as Button


# Called when the node enters the scene tree for the first time.
func _ready():
	handle_connecting_signals()
	

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
func on_help_pressed() -> void:
	margin_container.visible = false;
	help_menu.visible = true
func on_exit_pressed() -> void:
	get_tree().quit()
func on_exit_help_menu() -> void:
	margin_container.visible = true
	help_menu.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	help_button.button_down.connect(on_help_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	help_menu.exit_help_menu.connect(on_exit_help_menu)
