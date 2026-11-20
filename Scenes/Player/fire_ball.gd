extends Area2D

var speed = 100;
var damage = 5;
var attack_size = 1.0;
var knockback_strength = 50
var hp = 1;

var target = Vector2.ZERO;
var angle = Vector2.ZERO;

@onready var player = get_tree().get_first_node_in_group("player");
@onready var timer = $Timer;
var projectile_effect: GPUParticles2D;

signal remove_from_array(object: Object) #Sinal emitido para a hurtbox do tipo HitOnce 

func _ready():
	angle = global_position.direction_to(target);
	rotation = angle.angle() + deg_to_rad(135);
	timer.start();
	projectile_effect = ParticleFx.add_effect("fire_ball", global_position, self)
	
func _physics_process(delta: float) -> void:
	position += angle * speed * delta;

## deleta o ataque após acertar ou após o timer acabar.
func enemy_hit(charge = 1):
	hp -= charge;
	if hp <= 0:
		remove_from_array.emit(self)
		queue_free();

func _on_timer_timeout() -> void:
	remove_from_array.emit(self)
	queue_free();


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	remove_from_array.emit(self)
	queue_free();
