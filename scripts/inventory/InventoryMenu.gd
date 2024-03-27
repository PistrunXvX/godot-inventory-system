extends ContainerSlot

func _ready():
  display_item_slot(Inventory.cols, Inventory.rows)
  await get_tree()
  position = (get_viewport_rect().size - size) / 2
