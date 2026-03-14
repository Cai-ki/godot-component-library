## UIRating — Standalone Component
## Star rating control with hover preview and half-star support.
##
## Usage:
##   var rating := UIRating.new()
##   rating.value = 3.5
##   rating.max_stars = 5
##   rating.rating_changed.connect(func(v): print(v))
##   parent.add_child(rating)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIRating
extends Control

signal rating_changed(new_value: float)

enum Size { SM, MD, LG, XL }

@export var value: float = 0.0:
	set(v):
		value = clampf(v, 0.0, float(max_stars))
		queue_redraw()

@export var max_stars: int = 5:
	set(v):
		max_stars = maxi(v, 1)
		value = clampf(value, 0.0, float(max_stars))
		_update_min_size()
		queue_redraw()

@export var star_size: Size = Size.MD:
	set(v):
		star_size = v
		_update_min_size()
		queue_redraw()

@export var half_stars: bool = true

@export var readonly: bool = false:
	set(v):
		readonly = v
		if readonly:
			mouse_default_cursor_shape = Control.CURSOR_ARROW
		else:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		queue_redraw()

@export var accent_color: Color = Color("FB923C"):  # UITheme.WARNING
	set(v):
		accent_color = v
		queue_redraw()

@export var show_value_label: bool = false:
	set(v):
		show_value_label = v
		_update_min_size()
		queue_redraw()

# ── Private vars ──────────────────────────────────────────────
var _hover_value: float = -1.0
const GAP := 4.0
const LABEL_W := 36.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if not readonly:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_update_min_size()


func _update_min_size() -> void:
	var s := _get_star_px()
	var w := s * max_stars + GAP * (max_stars - 1)
	if show_value_label:
		w += LABEL_W
	custom_minimum_size = Vector2(w, s)


func _get_star_px() -> float:
	match star_size:
		Size.SM: return 16.0
		Size.LG: return 28.0
		Size.XL: return 36.0
		_: return 22.0


# ── Input ─────────────────────────────────────────────────────
func _gui_input(event: InputEvent) -> void:
	if readonly: return
	if event is InputEventMouseMotion:
		_hover_value = _pos_to_value(event.position.x)
		queue_redraw()
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			var new_v := _pos_to_value(mb.position.x)
			if new_v != value:
				value = new_v
				rating_changed.emit(value)
			accept_event()


func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_EXIT:
		_hover_value = -1.0
		queue_redraw()


func _pos_to_value(x: float) -> float:
	var s := _get_star_px()
	var total_w := s + GAP
	var star_idx := floorf(x / total_w)
	var within := x - star_idx * total_w
	var frac := within / s

	var val: float
	if half_stars:
		if frac <= 0.5:
			val = star_idx + 0.5
		else:
			val = star_idx + 1.0
	else:
		val = star_idx + 1.0

	return clampf(val, 0.5 if half_stars else 1.0, float(max_stars))


# ── Draw ──────────────────────────────────────────────────────
func _draw() -> void:
	var s := _get_star_px()
	var display_val := _hover_value if _hover_value > 0.0 else value

	for i in range(max_stars):
		var x := float(i) * (s + GAP)
		var center := Vector2(x + s * 0.5, s * 0.5)
		var filled: float  # 0.0, 0.5, or 1.0

		var star_num := float(i + 1)
		if display_val >= star_num:
			filled = 1.0
		elif display_val >= star_num - 0.5:
			filled = 0.5
		else:
			filled = 0.0

		_draw_star(center, s * 0.45, filled)

	# Value label
	if show_value_label:
		var label_x := float(max_stars) * (s + GAP) + 4.0
		var font := ThemeDB.fallback_font
		var fs := _get_label_font_size()
		var txt := "%.1f" % display_val
		var text_h := font.get_ascent(fs)
		draw_string(font, Vector2(label_x, s * 0.5 + text_h * 0.35), txt,
			HORIZONTAL_ALIGNMENT_LEFT, -1, fs, UITheme.TEXT_SECONDARY)


func _get_label_font_size() -> int:
	match star_size:
		Size.SM: return UITheme.FONT_XS
		Size.LG: return UITheme.FONT_BASE
		Size.XL: return UITheme.FONT_LG
		_: return UITheme.FONT_SM


func _draw_star(center: Vector2, radius: float, filled: float) -> void:
	var points := _star_points(center, radius, radius * 0.45)

	if filled >= 1.0:
		# Full star
		draw_colored_polygon(points, accent_color)
	elif filled >= 0.5:
		# Half star: left half filled, right half empty
		# Draw empty outline first
		_draw_star_outline(center, radius, UITheme.BORDER_STRONG)
		# Clip left half — draw filled polygon and use the left portion
		var left_points: PackedVector2Array = PackedVector2Array()
		for p in points:
			if p.x <= center.x:
				left_points.append(p)
			else:
				# Clip to center x
				left_points.append(Vector2(center.x, p.y))
		if left_points.size() >= 3:
			draw_colored_polygon(left_points, accent_color)
	else:
		# Empty star
		_draw_star_outline(center, radius, UITheme.BORDER_STRONG)


func _draw_star_outline(center: Vector2, radius: float, color: Color) -> void:
	var points := _star_points(center, radius, radius * 0.45)
	# Draw outline by connecting points
	for i in range(points.size()):
		var next_i: int = (i + 1) % points.size()
		draw_line(points[i], points[next_i], color, 1.5, true)


func _star_points(center: Vector2, outer_r: float, inner_r: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var angle_step := TAU / 10.0
	var start_angle := -PI / 2.0  # Point upward
	for i in range(10):
		var angle := start_angle + angle_step * i
		var r := outer_r if i % 2 == 0 else inner_r
		pts.append(center + Vector2(cos(angle), sin(angle)) * r)
	return pts
