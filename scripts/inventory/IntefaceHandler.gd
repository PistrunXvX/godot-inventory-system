extends Node2D

@onready var inventory_menu = $UI/Inventory

func _unhandled_input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_menu.visible = !inventory_menu.visible
