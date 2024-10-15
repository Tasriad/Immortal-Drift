extends CharacterBody2D

# Movement speed of the ghost
const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("ghost_front_idle")  # Default idle animation

func _physics_process(delta):
	ghost_movement(delta)  # Handle ghost movement

func ghost_movement(delta):
	# Check for input and move the ghost accordingly
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		$AnimatedSprite2D.flip_h = false
		play_animation(true)
		velocity.x = speed
		velocity.y = 0

	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		$AnimatedSprite2D.flip_h = false
		play_animation(true)
		velocity.x = -speed
		velocity.y = 0

	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_animation(true)
		velocity.y = speed
		velocity.x = 0

	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_animation(true)
		velocity.y = -speed
		velocity.x = 0

	else:
		velocity.x = 0
		velocity.y = 0
		play_animation(false)  # Idle animation when not moving

	# Use move_and_slide to apply movement
	move_and_slide()

# Function to play the correct animation based on movement and direction
func play_animation(is_moving):
	if current_dir == "right":
		if is_moving:
			$AnimatedSprite2D.play("ghost_right")
		else:
			$AnimatedSprite2D.play("ghost_right")
	elif current_dir == "left":
		if is_moving:
			$AnimatedSprite2D.play("ghost_left")
		else:
			$AnimatedSprite2D.play("ghost_left")
	elif current_dir == "down":
		if is_moving:
			$AnimatedSprite2D.play("ghost_front")
		else:
			$AnimatedSprite2D.play("ghost_front")
	elif current_dir == "up":
		if is_moving:
			$AnimatedSprite2D.play("ghost_back")
		else:
			$AnimatedSprite2D.play("ghost_back")
