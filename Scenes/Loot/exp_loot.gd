extends Area2D
class_name ExperienceLoot

@export var experience = 1

# Dicionário com os sprites de cada coletável por quantidade de EXP concedida
const EXP_SIZES = {
	"N": {
		"max_exp": 5,
		"sprite":  preload("res://Assets/Loot/exp_caju.png")
		}, 
	"L": {
		"max_exp": 25,
		"sprite":preload("res://Assets/Loot/exp_guarana.png")
		},
	"XL": {
		"max_exp": 100,
		"sprite": preload("res://Assets/Loot/exp_acai.png")
		} 
	}

var target = null
var speed = 0

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var collect_sfx = $SFXCollect

func _ready() -> void:
	sprite.texture = EXP_SIZES[_get_exp_size(experience)]["sprite"]


func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, speed)
		speed *= 2*delta


func collect():
	collect_sfx.play()
	collision.call_deferred("set","disabled", true)
	sprite.visible = false
	return experience


func _get_exp_size(exp_amount: int) -> String:
	for size in EXP_SIZES:
		if exp_amount <= EXP_SIZES[size]["max_exp"]:
			return size
	
	return EXP_SIZES.keys()[-1]


func _on_sfx_collect_finished() -> void:
	queue_free()
