extends "res://scripts/npc_soldier.gd"  # Inherit from the base player script

# NPC speed and distances

# Idle state variables
var idle_time = 0
var idle_duration = 0  # The duration of the current idle animation
var is_idle = false

# Define idle durations for each idle animation (in seconds)
const IDLE_DURATION_SIDE = 2.0  # Duration for npc_goat_idle_side
const IDLE_DURATION_UP = 1.5  # Duration for npc_goat_idle_up
const IDLE_DURATION_DOWN = 2.5  # Duration for npc_goat_idle_down

func _ready():
    # Save the original position to set movement bounds
    original_position = position

    # Randomly set the initial move direction (either horizontal or vertical)
    if randi() % 2 == 0:  # Even number for horizontal movement
        move_direction = Vector2(randf_range(-1, 1), 0).normalized()
    else:  # Odd number for vertical movement
        move_direction = Vector2(0, randf_range(-1, 1)).normalized()

func _physics_process(delta):
    if is_idle:
        handle_idle(delta)  # Handle idle behavior
    else:
        move_npc(delta)  # Handle movement

# Function to move the NPC back and forth in all directions
func move_npc(delta):
    # Determine animation based on move direction
    if move_direction.x > 0:
        $AnimatedSprite2D.play("npc_goat_walk_side")
    elif move_direction.x < 0:
        $AnimatedSprite2D.play("npc_goat_walk_side")
        $AnimatedSprite2D.flip_h = true  # Flip sprite for left movement
    elif move_direction.y > 0:
        $AnimatedSprite2D.play("npc_goat_walk_down")
    elif move_direction.y < 0:
        $AnimatedSprite2D.play("npc_goat_walk_up")

    # Move the NPC
    position += move_direction * speed * delta

    # Check for distance traveled in the current direction
    if abs(position.x - original_position.x) >= distance or abs(position.y - original_position.y) >= distance:
        move_direction *= -1  # Flip direction
        $AnimatedSprite2D.flip_h = move_direction.x < 0  # Flip sprite based on direction

    # Randomly decide to go idle
    if randf() < 0.01:  # Small chance to go idle every frame
        enter_idle_state()

# Function to handle idle animations
func handle_idle(delta):
    idle_time += delta
    if idle_time >= idle_duration:  # If idle duration is over, go back to walking
        exit_idle_state()

# Enter the idle state and play a random idle animation
func enter_idle_state():
    is_idle = true
    idle_time = 0
    
    # Determine which idle animation to play based on move direction
    var idle_animation = ""
    
    if move_direction.x > 0:
        idle_animation = "npc_goat_idle_side"
        idle_duration = IDLE_DURATION_SIDE  # Set idle duration for side
    elif move_direction.x < 0:
        idle_animation = "npc_goat_idle_side"
        idle_duration = IDLE_DURATION_SIDE  # Set idle duration for side
    elif move_direction.y > 0:
        idle_animation = "npc_goat_idle_down"
        idle_duration = IDLE_DURATION_DOWN  # Set idle duration for down
    elif move_direction.y < 0:
        idle_animation = "npc_goat_idle_up"
        idle_duration = IDLE_DURATION_UP  # Set idle duration for up
    
    $AnimatedSprite2D.play(idle_animation)

# Exit the idle state and go back to walking
func exit_idle_state():
    is_idle = false

func _on_animated_sprite_2d_animation_finished() -> void:
    if is_idle:
        exit_idle_state()
