extends CharacterBody2D
signal vida_alterada(vida_atual: int);
@export var vida_maxima: int = 100;
var vida_atual: int;
var esta_morto = false;
var original_speed = 80.0;
var actual_speed = original_speed;
var is_dash_ready = true;
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	vida_atual = vida_maxima
## chama a função 60 vezes por segundo
func _physics_process(delta):
	if esta_morto:
		return
	movement();
	if Input.is_action_just_pressed("dash") and is_dash_ready:
		is_dash_ready = false;
		$DashCooldown.start();
		dash();

func movement():
	## .get_action_strength retorna 1 se a ação estiver sendo executada, e 0 caso contrário.
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left");
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up");
	## Vector2 que indica a direção em que o jogador está se movendo.
	var dir = Vector2(x_mov, y_mov);
	
	if dir.x > 0:
		sprite.flip_h = false;
		sprite.play("walk");
	elif dir.x < 0:
		sprite.flip_h = true;
		sprite.play("walk");
	elif dir.y > 0 or dir.y < 0:
		sprite.play("walk");
	else:
		sprite.play("idle");
	
	velocity = dir.normalized() * actual_speed;
	move_and_slide();

func dash():
	actual_speed = original_speed * 3;
	## starta o timer de 0.5 segundos.
	$DashTimer.start();

## signal recebido quando o timer acaba.
func _on_timer_timeout() -> void:
	actual_speed = original_speed;

func _on_dash_cooldown_timeout() -> void:
	is_dash_ready = true;
	
func receber_dano(quantidade: int) -> void:
	if esta_morto or quantidade <= 0:
		return
	vida_atual = max(vida_atual - quantidade, 0)
	vida_alterada.emit(vida_atual);
	if vida_atual <= 0:
		morrer()
func morrer() -> void:
	esta_morto = true
	velocity = Vector2.ZERO
