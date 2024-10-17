extends CharacterBody2D

# NPC speed and distances
@export var speed = 50
@export var distance = 100
var move_direction = Vector2(1, 0)  # Initially moving to the right
var original_position

func _ready():
    # Save the original position to set movement bounds
    original_position = position

func _physics_process(delta):
    move_npc(delta)

# Function to move the NPC back and forth
func move_npc(delta):
    $AnimatedSprite2D.play("npc_soldier_walk")  # Play walking animation
    
    # Move the NPC
    position += move_direction * speed * delta

    # Reverse direction if NPC reaches the set distance
    if abs(position.x - original_position.x) >= distance:
        move_direction *= -1  # Flip direction
        $AnimatedSprite2D.flip_h = move_direction.x < 0  # Flip sprite based on direction
