extends CharacterBody2D

var original_speed = 50.0;
var actual_speed = original_speed;

## chama a função 60 vezes por segundo
func _physics_process(delta):
	movement();
	if Input.is_action_just_pressed("dash"):
		dash();

func movement():
	## .get_action_strength retorna 1 se a ação estiver sendo executada, e 0 caso contrário.
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left");
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up");
	## Vector2 que indica a direção em que o jogador está se movendo.
	var dir = Vector2(x_mov, y_mov);
	print(dir);
	velocity = dir.normalized() * actual_speed;
	move_and_slide();

func dash():
	actual_speed = original_speed * 4;
	## starta o timer de 0.5 segundos.
	$Timer.start();

## signal recebido quando o timer acaba.
func _on_timer_timeout() -> void:
	actual_speed = original_speed;
