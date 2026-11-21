class_name Enemy
extends CharacterBody2D

@export var movement_speed: float = 20.0
@export var hp = 10;
## O quão rápido o inimigo se recupera do knockback
@export var knockback_recovery = 3.5
## A quantidade de exp que a fruta que o inimigo dropa concede
@export var exp_drop = 1;
var knockback = Vector2.ZERO


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var loot_base: Node2D = get_tree().get_first_node_in_group("loot")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var danoInimigo: AudioStreamPlayer = $danoInimigo

const EXPLOSION_PARTICLE: PackedScene = preload("res://Assets/Shaders/pixel_explosion_particle.tscn")
const EXP_FRUIT: PackedScene = preload("res://Scenes/Loot/exp_fruit.tscn")

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
			
	

func die():
		remove_from_array.emit(self)
		var death_particle = EXPLOSION_PARTICLE.instantiate()
		get_tree().current_scene.add_child(death_particle)
		death_particle.emit(sprite)
		var new_fruit = EXP_FRUIT.instantiate()
		new_fruit.global_position = global_position
		new_fruit.experience = exp_drop
		loot_base.call_deferred("add_child", new_fruit)
		queue_free();

func _on_hurt_box_hurt(damage: Variant, angle: Variant, knockback_strength: Variant) -> void:
	hp -= damage;
	knockback = angle * knockback_strength
	danoInimigo.play()
	if hp <= 0:
		danoInimigo.reparent(get_parent())
		danoInimigo.finished.connect(danoInimigo.queue_free)
		die()
	else:
		anim.play("hitflash")
		
