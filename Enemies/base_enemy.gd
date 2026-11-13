class_name Enemy
extends CharacterBody2D


@export var movement_speed: float = 20.0
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("wobble")


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
	
	if velocity.x:
		sprite.flip_v = velocity.x >= 1
		
