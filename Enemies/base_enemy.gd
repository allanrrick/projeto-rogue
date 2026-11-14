class_name Enemy
extends CharacterBody2D

@export var movement_speed: float = 20.0
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var hp = 10;

func _ready() -> void:
	anim.play("wobble")


func _physics_process(_delta: float) -> void:
	movement();
	
	
func movement():
	var direction: Vector2 = global_position.direction_to(player.global_position)
	
	if direction.x > 0:
		sprite.flip_h = true;
		sprite.play("walk");
	elif direction.x < 0:
		sprite.flip_h = false;
		sprite.play("walk");
	elif direction.y > 0 or direction.y < 0:
		sprite.play("walk");
	else:
		sprite.play("idle");
	velocity = direction * movement_speed
	
	move_and_slide()
	

func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage;
	if hp <= 0:
		queue_free();
