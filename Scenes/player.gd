extends CharacterBody2D

var movement_speed = 50.0;

## chama a função 60 vezes por segundo
func _physics_process(delta):
	movement();

func movement():
	## .get_action_strength retorna 1 se a ação estiver sendo executada, e 0 caso contrário.
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left");
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up");
	## Vector2 que indica a direção em que o jogador está se movendo.
	var dir = Vector2(x_mov, y_mov);
	print(dir);
	velocity = dir.normalized() * movement_speed;
	move_and_slide();
