## UIDivider — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIDivider
extends Control

@export var divider_label: String = "":
	set(v): divider_label = v; queue_redraw(); _update_min()

@export var divider_color: Color = UITheme.BORDER:
	set(v): divider_color = v; queue_redraw()

@export var thickness: int = 1:
	set(v): thickness = v; queue_redraw()

@export var vertical: bool = false:
	set(v): vertical = v; _update_min(); queue_redraw()

func _ready() -> void:
	_update_min()

func _update_min() -> void:
	if vertical:
		custom_minimum_size = Vector2(max(4, thickness + 4), 20)
		size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		size_flags_vertical   = Control.SIZE_EXPAND_FILL
	else:
		custom_minimum_size = Vector2(20, 22 if divider_label != "" else max(4, thickness + 4))
		size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _draw() -> void:
	if vertical:
		var vcx := size.x * 0.5
		draw_rect(Rect2(vcx - thickness * 0.5, 0, thickness, size.y), divider_color)
		return

	if divider_label == "":
		var hcy := size.y * 0.5
		draw_rect(Rect2(0, hcy - thickness * 0.5, size.x, thickness), divider_color)
		return

	# Label with lines on each side
	var font      := ThemeDB.fallback_font
	var fs        := UITheme.FONT_SM
	var tsz       := font.get_string_size(divider_label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var pad       := 8.0
	var text_w    := tsz.x + pad * 2
	var cx        := size.x * 0.5
	var cy        := size.y * 0.5

	draw_rect(Rect2(0, cy - thickness * 0.5, cx - text_w * 0.5, thickness), divider_color)
	draw_rect(Rect2(cx + text_w * 0.5, cy - thickness * 0.5,
		size.x - cx - text_w * 0.5, thickness), divider_color)
	draw_string(font, Vector2(cx - tsz.x * 0.5, cy + tsz.y * 0.3),
		divider_label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, UITheme.TEXT_MUTED)
