
extends Node2D

@export var raio: float = 60.0
@export var velocidade: float = 2.0

@onready var osso1: Area2D = $Osso1
@onready var osso2: Area2D = $Osso2

var angulo: float = 0.0

func _process(delta: float) -> void:
	angulo += velocidade * delta

	osso1.position = Vector2(
		cos(angulo) * raio,
		sin(angulo) * raio
	)

	osso2.position = Vector2(
		cos(angulo + PI) * raio,
		sin(angulo + PI) * raio
	)
