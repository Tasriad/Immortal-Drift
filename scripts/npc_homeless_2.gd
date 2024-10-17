extends "res://scripts/npc_soldier.gd"  # Inherit from the base player script

# NPC speed and distances

# Idle state variables
var idle_time = 0
var idle_duration = 0  # The duration of the current idle animation
var is_idle = false

# Define idle durations for each idle animation (in seconds)
const IDLE_DURATION_1 = 2.0  # Duration for npc_homeless_idle1
const IDLE_DURATION_2 = 1.5  # Duration for npc_homeless_idle2

func _ready():
    # Save the original position to set movement bounds
    original_position = position

func _physics_process(delta):
    if is_idle:
        handle_idle(delta)  # Handle idle behavior
    else:
        move_npc(delta)  # Handle movement

# Function to move the NPC back and forth
func move_npc(delta):
    $AnimatedSprite2D.play("npc_homeless2_walk")  # Play walking animation
    
    # Move the NPC
    position += move_direction * speed * delta

    # Reverse direction if NPC reaches the set distance
    if abs(position.x - original_position.x) >= distance:
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
    
    # Randomly select one of the 3 idle animations and set their duration
    var random_idle = randi() % 2
    var idle_animation = ""
    
    if random_idle == 0:
        idle_animation = "npc_homeless2_idle1"
        idle_duration = IDLE_DURATION_1  # Set idle duration for idle1
    elif random_idle == 1:
        idle_animation = "npc_homeless2_idle2"
        idle_duration = IDLE_DURATION_2  # Set idle duration for idle2
    
    $AnimatedSprite2D.play(idle_animation)

# Exit the idle state and go back to walking
func exit_idle_state():
    is_idle = false

func _on_animated_sprite_2d_animation_finished() -> void:
    if is_idle:
        exit_idle_state()
