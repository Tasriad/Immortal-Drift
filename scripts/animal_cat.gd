extends CharacterBody2D

func _ready():
    # Play the idle animation when the NPC is ready
    $AnimatedSprite2D.play("cat_idle")
