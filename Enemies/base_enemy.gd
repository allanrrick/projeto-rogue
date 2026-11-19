class_name Enemy
extends CharacterBody2D

@export var movement_speed: float = 20.0
@export var hp = 10;
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

const EXPLOSION_PARTICLE = preload("res://Assets/Shaders/pixel_explosion_particle.tscn")

signal remove_from_array(object: Object) #Sinal emitido para a hurtbox do tipo HitOnce 

func _ready() -> void:
	anim.play("wobble")


func _physics_process(_delta: float) -> void:
	movement();
	
	
func movement():
	var direction: Vector2 = global_position.direction_to(player.global_position)
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)

	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0:
		sprite.flip_h = false;
		sprite.play("walk");
	elif direction.x < 0:
		sprite.flip_h = true;
		sprite.play("walk");
	elif direction.y > 0 or direction.y < 0:
		sprite.play("walk");
	else:
		sprite.play("idle");
			
	

func _on_hurt_box_hurt(damage: Variant, angle: Variant, knockback_strength: Variant) -> void:
	hp -= damage;
	knockback = angle * knockback_strength
	if hp <= 0:
		remove_from_array.emit(self)
		var death_particle = EXPLOSION_PARTICLE.instantiate()
		get_tree().current_scene.add_child(death_particle)
		death_particle.emit(sprite)
		queue_free();
	else:
		anim.play("hitflash")
		
