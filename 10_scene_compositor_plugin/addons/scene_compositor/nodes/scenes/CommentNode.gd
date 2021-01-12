tool
extends BaseNode
class_name CommentNode

onready var _text_control : Control = $TextEditControl

func _on_resize_request(new_minsize):
	_set_content_size(new_minsize)
	rect_size = new_minsize

func _set_content_size(size):
	if not is_inside_tree():
		return
	_text_control.rect_min_size = Vector2(-1, size.y-35)


