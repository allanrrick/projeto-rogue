extends CharacterBody2D

## HP
signal vida_alterada(vida_atual: int);
@export var vida_maxima: int = 100;
var vida_atual: int;
var esta_morto = false;

## Movement
var original_speed = 60.0;
var actual_speed = original_speed;
var is_dash_ready = true;

## Leveling
var current_exp = 0
var current_lvl = 1
var collected_exp = 0


@onready var sprite = $AnimatedSprite2D
@onready var som_dano: AudioStreamPlayer = $SomDano
@onready var som_fireBall: AudioStreamPlayer = $fireBallSound
@onready var anim = $AnimationPlayer
var particle_interval = 0.05;
var particle_elapsed = 0.0;

##GUI
@onready var expBar = $GUILayer/GUI/ExperienceBar
@onready var lblLevel = $GUILayer/GUI/ExperienceBar/LabelLevel

## Attacks
var fireBall = preload("res://Scenes/Player/fire_ball.tscn");

## AttacksNodes
@onready var fireBallTimer = get_node("%FireBallTimer");
@onready var fireBallAttackTimer = get_node("%FireBallAttackTimer");

# FireBall
var fireball_ammo = 0;
var fireball_baseammo = 1;
var fireball_attackSpeed = 1.5;

# Enemy
var enemies_close = [];

func _ready() -> void:
	vida_atual = vida_maxima
	_set_exp_bar(current_exp, _calculate_exp_cap())
	lblLevel.text = str("Level: ", current_lvl)
	attack();

## chama a função 60 vezes por segundo
func _physics_process(delta):
	if esta_morto:
		return
	movement();
	if Input.is_action_just_pressed("dash") and is_dash_ready:
		is_dash_ready = false;
		$DashCooldown.start();
		dash();
		
	if not $DashTimer.is_stopped():
		particle_elapsed += delta;

	if particle_elapsed >= particle_interval:
		particle_elapsed = 0.0;
		ParticleFx.add_effect("fire_dash", global_position + Vector2(0, 15));
	

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
	particle_elapsed = 0.0;
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
	som_dano.play();
	vida_alterada.emit(vida_atual);
	print(vida_atual);
	if vida_atual <= 0:
		morrer()
		return
	anim.play("hitflash")

func morrer() -> void:
	esta_morto = true
	velocity = Vector2.ZERO

func _on_hurt_box_hurt(damage: Variant, _angle, _knockback) -> void:
	receber_dano(damage);

func attack():
	fireBallTimer.wait_time = fireball_attackSpeed;
	if fireBallTimer.is_stopped():
		fireBallTimer.start();


func _on_fire_ball_timer_timeout() -> void:
	fireball_ammo += fireball_baseammo;
	fireBallAttackTimer.start();

func _on_fire_ball_attack_timer_timeout() -> void:
	if fireball_ammo > 0:
		var fireball_attack = fireBall.instantiate();
		fireball_attack.position = position;
		fireball_attack.target = get_random_target();
		add_child(fireball_attack);
		som_fireBall.play()
		fireball_ammo -= 1;
		if fireball_ammo > 0:
			fireBallAttackTimer.start();
		else:
			fireBallAttackTimer.stop();

func get_random_target():
	if enemies_close.size() > 0:
		return enemies_close.pick_random().global_position;
	else:
		return Vector2.UP;

func _on_enemy_scan_body_entered(body: Node2D) -> void:
	if not enemies_close.has(body):
		enemies_close.append(body);

func _on_enemy_scan_body_exited(body: Node2D) -> void:
	if enemies_close.has(body):
		enemies_close.erase(body);



func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self
	

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var fruit_exp = area.collect()
		_calculate_experience(fruit_exp)


func _calculate_experience(fruit_exp: int):
	var exp_required = _calculate_exp_cap()
	collected_exp += fruit_exp
	if current_exp + collected_exp >= exp_required:
		collected_exp -= exp_required-current_exp
		current_lvl += 1
		lblLevel.text = str("Level: ", current_lvl)
		current_exp = 0
		_calculate_experience(0) # Chamada recursiva com 0 de exp para poder usar o EXP restante
	else:
		current_exp += collected_exp
		collected_exp = 0
		
	_set_exp_bar(current_exp, exp_required)
	
func _calculate_exp_cap():
	var exp_cap = current_lvl
	if current_lvl < 20:
		exp_cap = current_lvl * 5
	elif current_lvl < 40:
		exp_cap = 95 + (current_lvl - 19) * 8 
	else:
		exp_cap = 255 + (current_lvl - 39) * 12
		
	return exp_cap


func _set_exp_bar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
	
