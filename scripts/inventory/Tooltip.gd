extends ColorRect

@onready var name_label = $MarginContainer/NameLabel
@onready var description_label = $MarginContainer/DescriptionLabel

func _process(delta):
	position = get_global_mouse_position() + Vector2.ONE * 4

func display_info(item):
	name_label.text = item.name
	description_label.text = item.description
