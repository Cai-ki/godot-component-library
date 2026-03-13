## UIProgressRing — Standalone Component
## Circular progress indicator with animated fill arc.
##
## Usage:
##   var ring := UIProgressRing.new()
##   ring.value = 0.75
##   ring.progress_color = UITheme.SUCCESS
##   ring.animate_to(1.0)
##   parent.add_child(ring)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIProgressRing
extends Control

@export var value: float = 0.5:
	set(v):
		value = clampf(v, 0.0, 1.0)
		queue_redraw()
		if _pct: _pct.text = str(int(value * 100)) + "%"

@export var progress_color: Color = Color("6C63FF"):   # UITheme.PRIMARY
	set(v): progress_color = v; queue_redraw()

@export var ring_size: float = 80.0:
	set(v):
		ring_size = v
		custom_minimum_size = Vector2(v, v)
		if _pct: _pct.add_theme_font_size_override("font_size", _label_font_size())
		queue_redraw()

@export var thickness: float = 6.0:
	set(v): thickness = v; queue_redraw()

@export var show_label: bool = true:
	set(v): show_label = v; if _pct: _pct.visible = v

var _pct: Label


func _ready() -> void:
	custom_minimum_size = Vector2(ring_size, ring_size)
	_build()


# ── Public API ────────────────────────────────────────────────────────────────

func animate_to(target: float, duration: float = 0.5) -> void:
	var tw := create_tween()
	tw.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "value", clampf(target, 0.0, 1.0), duration)


# ── Build ─────────────────────────────────────────────────────────────────────

func _build() -> void:
	_pct = Label.new()
	_pct.text = str(int(value * 100)) + "%"
	_pct.visible = show_label
	_pct.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pct.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_pct.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pct.add_theme_font_size_override("font_size", _label_font_size())
	_pct.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	add_child(_pct)


func _label_font_size() -> int:
	return maxi(11, int(ring_size * 0.2))


# ── Draw ──────────────────────────────────────────────────────────────────────

func _draw() -> void:
	var center := size / 2.0
	var radius := minf(size.x, size.y) / 2.0 - thickness / 2.0

	# Track (full circle background)
	draw_arc(center, radius, 0.0, TAU, 64, UITheme.SURFACE_3, thickness, true)

	# Fill arc (from top, clockwise)
	if value > 0.001:
		var start := -PI / 2.0
		var sweep := TAU * value
		var points := maxi(4, int(64.0 * value))
		draw_arc(center, radius, start, start + sweep, points, progress_color, thickness, true)
