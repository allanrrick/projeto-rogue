class_name Enemy
extends CharacterBody2D

var player_encostado: Node2D
@export var movement_speed: float = 20.0
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

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
	


func _on_area_dano_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_encostado = body
		body.call("receber_dano", 10)
		$TimerDano.start()


func _on_timer_dano_timeout() -> void:
	if is_instance_valid(player_encostado):
		player_encostado.call("receber_dano", 10)


func _on_area_dano_body_exited(body: Node2D) -> void:
	if body == player_encostado:
		$TimerDano.stop()
		player_encostado = null
