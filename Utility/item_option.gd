extends ColorRect

@onready var lbl_name = $LabelName
@onready var lbl_desc = $LabelDescription
@onready var lbl_level = $LabelLevel
@onready var item_icon = $ItemBorder/ItemIcon


var mouse_over = false
var item = null

@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade", Callable(player, "upgrade_character"));
	if not item:
		item = "food"
	
	lbl_name.text = UpgradeDb.UPGRADES[item]["display_name"]
	lbl_desc.text = UpgradeDb.UPGRADES[item]["details"]
	lbl_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])


func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)

func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
