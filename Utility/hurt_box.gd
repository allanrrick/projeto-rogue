extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage, angle, knockback)

var hit_once_array = []

## executa quando duas areas colidirem
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if area.get("damage") != null:
			match HurtBoxType:
				0: #CoolDown
					## desabilita collision shape
					collision.call_deferred("set", "disabled", true);
					## inicia cooldown pro ataque
					disableTimer.start();
					
				1: #HitOnce
					if not hit_once_array.has(area):
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"): 
							if not area.is_connected("remove_from_array", Callable(self, "remove_from_hit_once_array")):
								area.connect("remove_from_array", Callable(self, "remove_from_hit_once_array"))
					else:
						return
				
				2: #DisableHitBox
					if area.has_method("tempdisable"): area.tempdisable()
			
			var damage = area.damage;
			var angle = area.get("angle") if area.get("angle") else Vector2.ZERO
			var knockback = area.get("knockback_strength") if area.get("knockback_strength") else 1
			
			hurt.emit(damage, angle, knockback);
			if area.has_method("enemy_hit"):
				area.enemy_hit(1);

func _remove_from_hit_once_array(object: Object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)


func _on_disable_timer_timeout() -> void:
	## habilita collision shape quando o cooldown terminar
	collision.call_deferred("set", "disabled", false);
