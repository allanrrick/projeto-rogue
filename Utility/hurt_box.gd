extends Area2D

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)

## executa quando duas areas colidirem
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if area.get("damage") != null:
			## desabilita collision shape
			collision.call_deferred("set", "disabled", true);
			## inicia cooldown pro ataque
			disableTimer.start();
			var damage = area.damage;
			hurt.emit(damage);
			if area.has_method("enemy_hit"):
				area.enemy_hit(1);

func _on_disable_timer_timeout() -> void:
	## habilita collision shape quando o cooldown terminar
	collision.call_deferred("set", "disabled", false);
