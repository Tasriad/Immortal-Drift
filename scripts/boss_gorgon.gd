extends "res://scripts/enemy_small_dragon.gd"  # Inherit from the base player script

# New variable to track which attack to use
var attack_index = 0  # To track the current attack index

func chase(delta):
    # If the Gorgon is not attacking, handle movement and chase animations
    if not attacking:  
        if player_chase and player == global.active_player:  # Only chase if the detected player is active
            var direction = player.position - position
            direction = direction.normalized()
            position += direction * speed * delta  # Use delta for frame-rate independent movement

            # Determine which animation to play based on player's relative position
            if abs(direction.x) > abs(direction.y):  # Player is more to the side
                $AnimatedSprite2D.play("gorgon_run")
                $AnimatedSprite2D.flip_h = direction.x < 0
            elif direction.y > 0:  # Player is below the character
                $AnimatedSprite2D.play("gorgon_run")
            else:  # Player is above the character
                $AnimatedSprite2D.play("gorgon_run")
        else:
            $AnimatedSprite2D.play("gorgon_idle")

# Function to attack the player with three different animations
func attack_player():
    if player_inattack_zone and slime_attack_cooldown and not attacking:  # Only attack if not currently attacking
        if global.active_player.has_method("take_damage") and global.active_player != null:
            attacking = true  # Set the attacking state to true

            # Play the corresponding attack animation based on attack index
            match attack_index:
                0:
                    print("Attack 1")
                    $AnimatedSprite2D.play("gorgon_attack1")
                1:
                    print("Attack 2")
                    $AnimatedSprite2D.play("gorgon_attack2")
                2:
                    print("Attack 3")
                    $AnimatedSprite2D.play("gorgon_attack3")

            # Deal damage to the player
            global.active_player.take_damage(slime_attack_damage)

            # Start the attack cooldown timer
            $attack_cooldown_timer.start()
            slime_attack_cooldown = false

            # Increment attack index and wrap around after the third attack
            attack_index = (attack_index + 1) % 3
        else:
            player_inattack_zone = false  # Reset attack zone if the player is no longer valid

# Called when player exits the attack zone
func _on_enemy_hitbox_body_exited(body):
    if body.has_method("player") and body == global.active_player:  # Check if the exiting body is the active player
        player_inattack_zone = false  # Reset the attack zone
        if attacking:  # If we were attacking, stop attacking immediately
            attacking = false  # Allow transition back to chasing/idle
            $AnimatedSprite2D.play("gorgon_idle")  # Optionally, reset to idle or walking state
