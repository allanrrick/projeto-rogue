extends CanvasLayer

@onready var player = $"../Player"
@onready var barra_vida = $"../Player/ProgressBar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	barra_vida.max_value = player.vida_maxima
	barra_vida.value = player.vida_atual
	player.vida_alterada.connect(atualizar_vida)

func atualizar_vida(nova_vida: int) -> void:
	barra_vida.value = nova_vida
