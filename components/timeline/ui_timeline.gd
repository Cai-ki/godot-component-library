## UITimeline — Standalone Component
## Vertical feed with colored dots/icons, connecting lines,
## timestamps, and content areas per item.
##
## Usage:
##   var tl := UITimeline.new()
##   tl.add_item("Deployed v2.0", "Production release", "2 hours ago", UITheme.SUCCESS)
##   tl.add_item("Code review", "PR #142 approved", "5 hours ago", UITheme.PRIMARY)
##   parent.add_child(tl)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UITimeline
extends VBoxContainer

var _items: Array[Dictionary] = []


func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 0)
	_rebuild()


## Add a timeline item.
## icon_text: emoji or single char for the dot (empty = solid dot)
func add_item(title: String, description: String = "", timestamp: String = "",
		color: Color = UITheme.PRIMARY, icon_text: String = "") -> void:
	_items.append({
		"title": title,
		"description": description,
		"timestamp": timestamp,
		"color": color,
		"icon": icon_text
	})
	if is_inside_tree():
		_rebuild.call_deferred()


func clear_items() -> void:
	_items.clear()
	if is_inside_tree():
		_rebuild.call_deferred()


func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()

	for i in _items.size():
		_build_item(i)


func _build_item(index: int) -> void:
	var item: Dictionary = _items[index]
	var is_last := index == _items.size() - 1
	var c: Color = item.get("color", UITheme.PRIMARY)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(row)

	# ── Left: dot + line column ──
	var left := VBoxContainer.new()
	left.add_theme_constant_override("separation", 0)
	left.custom_minimum_size.x = 32
	row.add_child(left)

	# Dot
	var dot_center := CenterContainer.new()
	left.add_child(dot_center)

	var dot_size := 28
	var icon_str: String = item.get("icon", "")
	if icon_str.is_empty():
		# Solid colored dot
		var dot := Control.new()
		dot.custom_minimum_size = Vector2(12, 12)
		var dot_draw_color := c
		dot.draw.connect(func():
			var center := dot.size / 2.0
			dot.draw_circle(center, 6.0, dot_draw_color)
		)
		dot_center.add_child(dot)
	else:
		# Icon circle
		var icon_panel := PanelContainer.new()
		icon_panel.custom_minimum_size = Vector2(dot_size, dot_size)
		var s := StyleBoxFlat.new()
		s.bg_color = Color(c.r, c.g, c.b, 0.15)
		s.corner_radius_top_left = UITheme.RADIUS_PILL
		s.corner_radius_top_right = UITheme.RADIUS_PILL
		s.corner_radius_bottom_left = UITheme.RADIUS_PILL
		s.corner_radius_bottom_right = UITheme.RADIUS_PILL
		icon_panel.add_theme_stylebox_override("panel", s)
		dot_center.add_child(icon_panel)

		var icon_center := CenterContainer.new()
		icon_panel.add_child(icon_center)
		var icon_lbl := Label.new()
		icon_lbl.text = icon_str
		icon_lbl.add_theme_font_size_override("font_size", 12)
		icon_lbl.add_theme_color_override("font_color", c)
		icon_center.add_child(icon_lbl)

	# Connecting line (if not last)
	if not is_last:
		var line_spacer := Control.new()
		line_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
		line_spacer.custom_minimum_size.y = 20
		var line_c := UITheme.BORDER
		line_spacer.draw.connect(func():
			var cx := line_spacer.size.x / 2.0
			line_spacer.draw_line(Vector2(cx, 0), Vector2(cx, line_spacer.size.y), line_c, 1.0)
		)
		left.add_child(line_spacer)

	# ── Right: content ──
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 4)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(content)

	# Title row (title + timestamp)
	var title_row := HBoxContainer.new()
	title_row.add_theme_constant_override("separation", 8)
	content.add_child(title_row)

	var title_lbl := Label.new()
	title_lbl.text = item.get("title", "")
	title_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	title_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	title_row.add_child(title_lbl)

	# Flexible spacer
	var flex := Control.new()
	flex.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_row.add_child(flex)

	var ts_text: String = item.get("timestamp", "")
	if not ts_text.is_empty():
		var ts_lbl := Label.new()
		ts_lbl.text = ts_text
		ts_lbl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
		ts_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		ts_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		title_row.add_child(ts_lbl)

	# Description
	var desc_text: String = item.get("description", "")
	if not desc_text.is_empty():
		var desc_lbl := Label.new()
		desc_lbl.text = desc_text
		desc_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
		desc_lbl.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(desc_lbl)

	# Bottom margin
	if not is_last:
		var margin := Control.new()
		margin.custom_minimum_size.y = 12
		content.add_child(margin)
