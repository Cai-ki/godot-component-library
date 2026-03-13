## UINotificationBadge — Standalone Component
## Red dot or count overlay that attaches to any parent control,
## positioned at the top-right corner.
##
## Usage:
##   var badge := UINotificationBadge.new()
##   badge.count = 5
##   my_button.add_child(badge)   # auto-positions at top-right
##
##   # Dot-only mode:
##   badge.count = 0              # shows red dot, no number
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UINotificationBadge
extends Control

@export var count: int = 0:
	set(v): count = maxi(v, 0); queue_redraw()

@export var badge_color: Color = UITheme.DANGER:
	set(v): badge_color = v; queue_redraw()

@export var max_count: int = 99:
	set(v): max_count = v; queue_redraw()

@export var show_zero: bool = false:
	set(v): show_zero = v; queue_redraw()

var _visible: bool:
	get: return count > 0 or show_zero


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 10
	_update_layout()


func _process(_delta: float) -> void:
	_update_layout()


func _update_layout() -> void:
	if not is_inside_tree(): return
	var p := get_parent_control()
	if p == null: return

	var ps := p.size
	if count > 0:
		var display := str(count) if count <= max_count else str(max_count) + "+"
		var font := ThemeDB.fallback_font
		var fs := 10
		var tsz := font.get_string_size(display, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		var w := maxf(18.0, tsz.x + 10.0)
		var h := 18.0
		custom_minimum_size = Vector2(w, h)
		size = Vector2(w, h)
		position = Vector2(ps.x - w * 0.6, -h * 0.4)
	else:
		custom_minimum_size = Vector2(10, 10)
		size = Vector2(10, 10)
		position = Vector2(ps.x - 8, -2)


func _draw() -> void:
	if not _visible: return

	if count > 0:
		_draw_count_badge()
	else:
		_draw_dot()


func _draw_dot() -> void:
	var center := size / 2.0
	draw_circle(center, 5.0, badge_color)


func _draw_count_badge() -> void:
	var display := str(count) if count <= max_count else str(max_count) + "+"
	var r := size.y / 2.0

	# Rounded rect background
	var _rect := Rect2(Vector2.ZERO, size)
	var pts := PackedVector2Array()
	var segments := 12

	# Top-left arc
	for i in range(segments + 1):
		var angle := PI + float(i) / segments * (PI / 2.0)
		pts.append(Vector2(r + cos(angle) * r, r + sin(angle) * r))
	# Top-right arc
	for i in range(segments + 1):
		var angle := -PI / 2.0 + float(i) / segments * (PI / 2.0)
		pts.append(Vector2(size.x - r + cos(angle) * r, r + sin(angle) * r))
	# Bottom-right arc
	for i in range(segments + 1):
		var angle := 0.0 + float(i) / segments * (PI / 2.0)
		pts.append(Vector2(size.x - r + cos(angle) * r, size.y - r + sin(angle) * r))
	# Bottom-left arc
	for i in range(segments + 1):
		var angle := PI / 2.0 + float(i) / segments * (PI / 2.0)
		pts.append(Vector2(r + cos(angle) * r, size.y - r + sin(angle) * r))

	draw_colored_polygon(pts, badge_color)

	# Text
	var font := ThemeDB.fallback_font
	var fs := 10
	var tsz := font.get_string_size(display, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var tpos := size / 2.0 + Vector2(-tsz.x * 0.5, tsz.y * 0.3)
	draw_string(font, tpos, display, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color.WHITE)
