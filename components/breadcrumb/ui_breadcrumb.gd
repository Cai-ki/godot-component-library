## UIBreadcrumb — Standalone Component
## Path navigation with clickable segments and separator characters.
##
## Usage:
##   var bc := UIBreadcrumb.new()
##   bc.items = PackedStringArray(["Home", "Products", "Detail"])
##   bc.segment_clicked.connect(func(i): print("navigate to", i))
##   parent.add_child(bc)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIBreadcrumb
extends HBoxContainer

signal segment_clicked(index: int)

@export var items: PackedStringArray = []:
	set(v): items = v; if is_inside_tree(): _rebuild.call_deferred()

@export var separator: String = "›":
	set(v): separator = v; if is_inside_tree(): _rebuild.call_deferred()

@export var active_color: Color = UITheme.TEXT_PRIMARY:
	set(v): active_color = v; if is_inside_tree(): _rebuild.call_deferred()

@export var inactive_color: Color = UITheme.TEXT_SECONDARY:
	set(v): inactive_color = v; if is_inside_tree(): _rebuild.call_deferred()

@export var separator_color: Color = UITheme.TEXT_MUTED:
	set(v): separator_color = v; if is_inside_tree(): _rebuild.call_deferred()


func _ready() -> void:
	add_theme_constant_override("separation", 0)
	_rebuild()


func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()

	for i in items.size():
		var is_last := i == items.size() - 1
		_build_segment(i, is_last)
		if not is_last:
			_build_separator()


func _build_segment(index: int, is_last: bool) -> void:
	var btn := Button.new()
	btn.text = items[index]
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if not is_last else Control.CURSOR_ARROW

	var font_c := active_color if is_last else inactive_color
	var hover_c := active_color if not is_last else active_color

	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	btn.add_theme_color_override("font_color", font_c)
	btn.add_theme_color_override("font_hover_color", hover_c)
	btn.add_theme_color_override("font_pressed_color", hover_c)

	# Transparent backgrounds
	var empty := StyleBoxFlat.new()
	empty.bg_color = Color.TRANSPARENT
	empty.content_margin_left = 6
	empty.content_margin_right = 6
	empty.content_margin_top = 4
	empty.content_margin_bottom = 4
	var hover_s := empty.duplicate()
	hover_s.bg_color = UITheme.SURFACE_3
	hover_s.corner_radius_top_left = UITheme.RADIUS_XS
	hover_s.corner_radius_top_right = UITheme.RADIUS_XS
	hover_s.corner_radius_bottom_left = UITheme.RADIUS_XS
	hover_s.corner_radius_bottom_right = UITheme.RADIUS_XS

	btn.add_theme_stylebox_override("normal", empty)
	btn.add_theme_stylebox_override("hover", hover_s if not is_last else empty)
	btn.add_theme_stylebox_override("pressed", hover_s if not is_last else empty)
	btn.add_theme_stylebox_override("focus", empty)

	if not is_last:
		var captured := index
		btn.pressed.connect(func(): segment_clicked.emit(captured))

	add_child(btn)


func _build_separator() -> void:
	var lbl := Label.new()
	lbl.text = " " + separator + " "
	lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	lbl.add_theme_color_override("font_color", separator_color)
	lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	add_child(lbl)
