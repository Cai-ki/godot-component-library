class_name UIPagination
extends HBoxContainer

## Pagination control with numbered page buttons, prev/next, and ellipsis.
## Emits page_changed(page) when user clicks a different page.

signal page_changed(page: int)

@export var total_pages: int = 1:
	set(v):
		total_pages = maxi(1, v)
		if is_inside_tree(): _rebuild.call_deferred()

@export var current_page: int = 1:
	set(v):
		var old := current_page
		current_page = clampi(v, 1, total_pages)
		if is_inside_tree() and current_page != old:
			_rebuild.call_deferred()

## Max number of page buttons between first and last (excluding ellipsis).
@export var visible_count: int = 5


func _ready() -> void:
	add_theme_constant_override("separation", 4)
	alignment = BoxContainer.ALIGNMENT_CENTER
	_rebuild()


func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()

	# Prev
	var prev := _nav_btn("←  Prev", current_page > 1)
	prev.pressed.connect(func():
		current_page -= 1
		page_changed.emit(current_page)
	)
	add_child(prev)

	# Page numbers
	for p in _calc_pages():
		if p == -1:
			var dots := Label.new()
			dots.text = "···"
			dots.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
			dots.add_theme_font_size_override("font_size", UITheme.FONT_SM)
			add_child(dots)
		else:
			var btn := _page_btn(p, p == current_page)
			var page: int = p  # capture for lambda
			btn.pressed.connect(func():
				current_page = page
				page_changed.emit(current_page)
			)
			add_child(btn)

	# Next
	var nxt := _nav_btn("Next  →", current_page < total_pages)
	nxt.pressed.connect(func():
		current_page += 1
		page_changed.emit(current_page)
	)
	add_child(nxt)


# ── Visible page calculation ─────────────────────────────────────────────────

func _calc_pages() -> Array:
	if total_pages <= visible_count + 2:
		var pages := []
		for i in range(1, total_pages + 1):
			pages.append(i)
		return pages

	var result := [1]
	@warning_ignore("integer_division")
	var half := visible_count / 2
	var start := maxi(2, current_page - half)
	var end   := mini(total_pages - 1, current_page + half)

	# Adjust window when near edges
	if start <= 3:
		end = maxi(end, visible_count)
		start = 2
	if end >= total_pages - 2:
		start = mini(start, total_pages - visible_count + 1)
		end = total_pages - 1

	start = maxi(2, start)
	end   = mini(total_pages - 1, end)

	if start > 2:
		result.append(-1)
	for i in range(start, end + 1):
		result.append(i)
	if end < total_pages - 1:
		result.append(-1)

	result.append(total_pages)
	return result


# ── Button factories ─────────────────────────────────────────────────────────

func _page_btn(page: int, active: bool) -> Button:
	var btn := Button.new()
	btn.text = str(page)
	btn.focus_mode = Control.FOCUS_NONE
	btn.custom_minimum_size = Vector2(34, 34)

	var bg:    Color = UITheme.PRIMARY    if active else Color(0, 0, 0, 0)
	var fg:    Color = Color.WHITE        if active else UITheme.TEXT_SECONDARY
	var hv_bg: Color = UITheme.PRIMARY    if active else UITheme.SURFACE_4
	var hv_fg: Color = Color.WHITE        if active else UITheme.TEXT_PRIMARY

	var n := StyleBoxFlat.new()
	n.bg_color = bg
	n.corner_radius_top_left = UITheme.RADIUS_SM; n.corner_radius_top_right = UITheme.RADIUS_SM
	n.corner_radius_bottom_left = UITheme.RADIUS_SM; n.corner_radius_bottom_right = UITheme.RADIUS_SM
	n.content_margin_left = 4; n.content_margin_right = 4

	var h := n.duplicate()
	h.bg_color = hv_bg

	btn.add_theme_stylebox_override("normal",  n)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_stylebox_override("focus",   n)
	btn.add_theme_color_override("font_color",       fg)
	btn.add_theme_color_override("font_hover_color", hv_fg)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	return btn


func _nav_btn(text: String, enabled: bool) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	btn.disabled = not enabled

	var n := StyleBoxFlat.new()
	n.bg_color = Color(0, 0, 0, 0)
	n.content_margin_left = 10; n.content_margin_right = 10
	n.content_margin_top  = 6;  n.content_margin_bottom = 6

	var h := n.duplicate()
	h.bg_color = UITheme.SURFACE_3
	h.corner_radius_top_left = UITheme.RADIUS_SM; h.corner_radius_top_right = UITheme.RADIUS_SM
	h.corner_radius_bottom_left = UITheme.RADIUS_SM; h.corner_radius_bottom_right = UITheme.RADIUS_SM

	btn.add_theme_stylebox_override("normal",  n)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_stylebox_override("focus",   n)
	btn.add_theme_color_override("font_color",          UITheme.TEXT_SECONDARY)
	btn.add_theme_color_override("font_hover_color",    UITheme.TEXT_PRIMARY)
	btn.add_theme_color_override("font_disabled_color", UITheme.TEXT_MUTED)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	return btn
