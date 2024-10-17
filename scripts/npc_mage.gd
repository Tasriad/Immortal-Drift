extends "res://scripts/npc_soldier.gd"  # Inherit from the base player script

# NPC speed and distances
func _ready():
    # Save the original position to set movement bounds
    original_position = position

func _physics_process(delta):
    move_npc(delta)

# Function to move the NPC back and forth
func move_npc(delta):
    $AnimatedSprite2D.play("npc_mage_walk")  # Play walking animation
    
    # Move the NPC
    position += move_direction * speed * delta

    # Reverse direction if NPC reaches the set distance
    if abs(position.x - original_position.x) >= distance:
        move_direction *= -1  # Flip direction
        $AnimatedSprite2D.flip_h = move_direction.x < 0  # Flip sprite based on direction
