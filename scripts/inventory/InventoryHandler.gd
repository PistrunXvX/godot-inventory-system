extends Control

@onready var drag_preview = $InventoryContainer/DragPreview
@onready var tooltip = $InventoryContainer/InventoryTooltip

func _ready():
	for item_slot in get_tree().get_nodes_in_group("items_slot"):
		var index = item_slot.get_index()
		item_slot.connect("gui_input", _on_ItemSlot_gui_input.bind(index))
		item_slot.connect("mouse_entered", show_tooltip.bind(index))
		item_slot.connect("mouse_exited", hide_tooltip)

func _unhandled_input(event):
	if event.is_action_pressed("ui_inventory"):
		# Не даем закрыть инвентарь пока взят предмет
		if visible && drag_preview.dragged_item: return
		visible = !visible
		hide_tooltip()

func _on_ItemSlot_gui_input(event, index):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			hide_tooltip()
			drag_item(index)
		if event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			hide_tooltip()
			split_item(index)

func drag_item(index):
	var inventory_item = Inventory.items[index]
	var dragged_item = drag_preview.dragged_item
	
	# Взять предмет
	if inventory_item && !dragged_item:
		drag_preview.dragged_item = Inventory.remove_item(index)
	# Бросить предмет
	if !inventory_item && dragged_item:
		drag_preview.dragged_item = Inventory.set_item(index, dragged_item)

	if inventory_item && dragged_item:
		# Стакнуть предмет
		if inventory_item.key == dragged_item.key && inventory_item.stackable:
			Inventory.set_item_quantity(index, dragged_item.quantity)
			drag_preview.dragged_item = {}
		# Свапнуть предмет
		else:
			drag_preview.dragged_item = Inventory.set_item(index, dragged_item)

func split_item(index):
	var inventory_item = Inventory.items[index]
	var dragged_item = drag_preview.dragged_item
	var split_amount
	var item
	
	 # Проверяем если предмет стакабл
	if !inventory_item || !inventory_item.stackable: return
	
	split_amount = ceil(inventory_item.quantity / 2.0)
	
	if dragged_item && inventory_item.key == dragged_item.key:
		drag_preview.dragged_item.quantity += split_amount
		Inventory.set_item_quantity(index, -split_amount)
	if !dragged_item:
		item = inventory_item.duplicate()
		item.quantity = split_amount
		drag_preview.dragged_item = item
		Inventory.set_item_quantity(index, -split_amount)

func show_tooltip(index):
	var inventory_item = Inventory.items[index]
	
	if inventory_item && !drag_preview.dragged_item:
		tooltip.display_info(inventory_item)
		tooltip.visible = true
	else:
		tooltip.visible = false

func hide_tooltip():
	tooltip.visible = false
