extends "res://scripts/player.gd"  # Inherit from the base player script

# Custom animations for the light_mage

var attack_type = 0  # Variable to track the current attack type

func _ready():
	$AnimatedSprite2D.play("light_mage_idle")  # Default idle animation


# Override the base movement method if necessary to apply custom animations
func play_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("light_mage_run_side")
		elif movement == 0:
			animation.play("light_mage_idle")

	elif dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("light_mage_run_side")
		elif movement == 0:
			animation.play("light_mage_idle")

	elif dir == "down":
		if movement == 1:
			animation.play("light_mage_run_side")
		elif movement == 0:
			animation.play("light_mage_idle")

	elif dir == "up":
		if movement == 1:
			animation.play("light_mage_run_side")
		elif movement == 0:
			animation.play("light_mage_idle")


# Overriding the attack method to include four different attacks for the light_mage
func attack():
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		$deal_attack_timer.start()
		match attack_type:
			0:
				attack1()
			1:
				attack2()
			2:
				attack3()
			3:
				attack4()

		# Cycle through the attack types after each attack
		attack_type = (attack_type + 1) % 4
	# When attack is released
	if Input.is_action_just_released("attack"):
		global.player_current_attack = false
		attack_ip = false
		$AnimatedSprite2D.play("light_mage_idle")  # Reset to idle animation		

# Methods for the different attacks

func attack1():
	var dir = current_dir
	if dir == "right":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("light_mage_attack1_side")
	elif dir == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("light_mage_attack1_side")
	elif dir == "down":
		$AnimatedSprite2D.play("light_mage_attack1_side")
	elif dir == "up":
		$AnimatedSprite2D.play("light_mage_attack1_side")

	$deal_attack_timer.start()  # Start the timer for dealing damage

func attack2():
	var dir = current_dir
	if dir == "right":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("light_mage_attack2_side")
	elif dir == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("light_mage_attack2_side")
	elif dir == "down":
		$AnimatedSprite2D.play("light_mage_attack2_side")
	elif dir == "up":
		$AnimatedSprite2D.play("light_mage_attack2_side")

	$deal_attack_timer.start()  # Start the timer for dealing damage

func attack3():
	var dir = current_dir
	if dir == "right":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("light_mage_attack3_side")
	elif dir == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("light_mage_attack3_side")
	elif dir == "down":
		$AnimatedSprite2D.play("light_mage_attack3_side")
	elif dir == "up":
		$AnimatedSprite2D.play("light_mage_attack3_side")

func attack4():
	var dir = current_dir
	if dir == "right":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("light_mage_attack4_side")
	elif dir == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("light_mage_attack4_side")
	elif dir == "down":
		$AnimatedSprite2D.play("light_mage_attack4_side")
	elif dir == "up":
		$AnimatedSprite2D.play("light_mage_attack4_side")
		
func possess():
	# This method is called when the ghost possesses this character
	global.active_player.queue_free()  # Remove the old active player	
	global.active_player = self  # Update the active player
	self.show()  # Make sure the character is visible
	self.position = global.ghost.position  # Move the character to the ghost's position

	# Optionally set up other parameters here, such as health or animations
		
