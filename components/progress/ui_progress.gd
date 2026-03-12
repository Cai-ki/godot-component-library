## UIProgress — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIProgress
extends Control

@export var value: float = 0.5:
	set(v):
		value = clampf(v, 0.0, 1.0)
		if _fill: _fill.anchor_right = value
		if _pct:  _pct.text = str(int(value * 100)) + "%"

@export var progress_color: Color = UITheme.PRIMARY:
	set(v): progress_color = v; if is_inside_tree(): _apply_colors()

@export var bar_height: int = 8:
	set(v): bar_height = v; if _bar: _bar.custom_minimum_size.y = v

@export var show_label: bool = false:
	set(v): show_label = v; if _pct: _pct.visible = v

@export var radius: int = UITheme.RADIUS_SM:
	set(v): radius = v; if is_inside_tree(): _apply_colors()

var _bar:   Control
var _track: PanelContainer
var _fill:  PanelContainer
var _pct:   Label

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size.y = bar_height
	_build()

# ── Public API ────────────────────────────────────
func animate_to(target: float, duration: float = 0.5) -> void:
	var t := create_tween()
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "value", clampf(target, 0.0, 1.0), duration)

# ── Internal ──────────────────────────────────────
func _build() -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(row)

	_bar = Control.new()
	_bar.custom_minimum_size.y = bar_height
	_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_bar.size_flags_vertical   = Control.SIZE_SHRINK_CENTER
	row.add_child(_bar)

	_track = PanelContainer.new()
	_track.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_bar.add_child(_track)

	_fill = PanelContainer.new()
	_fill.anchor_left = 0.0; _fill.anchor_top    = 0.0
	_fill.anchor_right = value; _fill.anchor_bottom = 1.0
	_fill.offset_left = 0; _fill.offset_top  = 0
	_fill.offset_right = 0; _fill.offset_bottom = 0
	_bar.add_child(_fill)

	_pct = Label.new()
	_pct.text = str(int(value * 100)) + "%"
	_pct.visible = show_label
	_pct.custom_minimum_size.x = 40
	_pct.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_pct.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	_pct.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	row.add_child(_pct)

	_apply_colors()

func _make_bar_style(bg: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.corner_radius_top_left     = radius; s.corner_radius_top_right    = radius
	s.corner_radius_bottom_left  = radius; s.corner_radius_bottom_right = radius
	return s

func _apply_colors() -> void:
	if _track: _track.add_theme_stylebox_override("panel", _make_bar_style(UITheme.SURFACE_3))
	if _fill:  _fill.add_theme_stylebox_override("panel",  _make_bar_style(progress_color))
