extends Node

const ICON_PATH = "res://Assets/Icons/Upgrades/"
const WEAPON_PATH = "res://Assets/Icons/Weapons/"


const UPGRADES = {
	"fireball1":{
		"icon": WEAPON_PATH + "fire_ball.png",
		"display_name": "Bola de Fogo",
		"details": "Uma bola flamejanto lançada aleatoriamente",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"fireball2":{
		"icon": WEAPON_PATH + "fire_ball.png",
		"display_name": "Bola de Fogo",
		"details": "1 bola de fogo adicional é lançada",
		"level": "Level: 2",
		"prerequisite": ["fireball1"],
		"type": "weapon"
	},
	"fireball3":{
		"icon": WEAPON_PATH + "fire_ball.png",
		"display_name": "Bola de Fogo",
		"details": "Bolas de fogo atravessam um inimigo adicional e causam +3 de dano",
		"level": "Level: 3",
		"prerequisite": ["fireball2"],
		"type": "weapon"
	},
	"fireball4":{
		"icon": WEAPON_PATH + "fire_ball.png",
		"display_name": "Bola de Fogo",
		"details": "2 bolas de fogo adicionais são lançadas",
		"level": "Level: 4",
		"prerequisite": ["fireball3"],
		"type": "weapon"
	},
	"armor1":{
		"icon": ICON_PATH + "carranca.png",
		"display_name": "Carranca",
		"details": "Reduz o dano recebido em 1 ponto",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2":{
		"icon": ICON_PATH + "carranca.png",
		"display_name": "Carranca",
		"details": "Reduz o dano recebido em 1 ponto adicional",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3":{
		"icon": ICON_PATH + "carranca.png",
		"display_name": "Carranca",
		"details": "Reduz o dano recebido em 1 ponto adicional",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4":{
		"icon": ICON_PATH + "carranca.png",
		"display_name": "Carranca",
		"details": "Reduz o dano recebido em 1 ponto adicional",
		"level": "Level: 3",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1":{
		"icon": ICON_PATH + "feather.png",
		"display_name": "Pena Veloz",
		"details": "Aumenta a Velocidade de Movimento em 50% do valor base",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2":{
		"icon": ICON_PATH + "feather.png",
		"display_name": "Pena Veloz",
		"details": "Aumenta a Velocidade de Movimento em um adicional de 50% do valor base",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3":{
		"icon": ICON_PATH + "feather.png",
		"display_name": "Pena Veloz",
		"details": "Aumenta a Velocidade de Movimento em um adicional de 50% do valor base",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"size1":{
		"icon": ICON_PATH + "upgrade_template.png",
		"display_name": "Tamanho do Projétil",
		"details": "Aumenta o tamanho dos projéteis em 10% do tamanho base",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"size2":{
		"icon": ICON_PATH + "upgrade_template.png",
		"display_name": "Tamanho do Projétil",
		"details": "Aumenta o tamanho dos projéteis em 10% do tamanho base",
		"level": "Level: 2",
		"prerequisite": ["size1"],
		"type": "upgrade"
	},
	"size3":{
		"icon": ICON_PATH + "upgrade_template.png",
		"display_name": "Tamanho do Projétil",
		"details": "Aumenta o tamanho dos projéteis em 10% do tamanho base",
		"level": "Level: 3",
		"prerequisite": ["size2"],
		"type": "upgrade"
	},
	"cooldown1":{
		"icon": ICON_PATH + "pipe.png",
		"display_name": "Cachimbo",
		"details": "Reduz a recarga das armas em 5% do valor base",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"cooldown2":{
		"icon": ICON_PATH + "pipe.png",
		"display_name": "Cachimbo",
		"details": "Reduz a recarga das armas em 5% do valor base",
		"level": "Level: 2",
		"prerequisite": ["cooldown1"],
		"type": "upgrade"
	},
	"cooldown3":{
		"icon": ICON_PATH + "pipe.png",
		"display_name": "Cachimbo",
		"details": "Reduz a recarga das armas em 5% do valor base",
		"level": "Level: 3",
		"prerequisite": ["cooldown2"],
		"type": "upgrade"
	},
	"amount1":{
		"icon": ICON_PATH + "cauldron.png",
		"display_name": "Caldeirão",
		"details": "Suas armas passam a disparar 1 projétil adicional",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"amount2":{
		"icon": ICON_PATH + "cauldron.png",
		"display_name": "Caldeirão",
		"details": "Suas armas disparam mais 1 projétil adicional",
		"level": "Level:2",
		"prerequisite": ["amount1"],
		"type": "upgrade"
	},
	"food":{
		"icon": ICON_PATH + "upgrade_template.png",
		"display_name": "Comida",
		"details": "Recupera 20 Pontos de Vida",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	},
	
}
