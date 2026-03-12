## UITag — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UITag
extends Control

signal removed(tag_text: String)

@export var tag_text: String = "Tag":
	set(v): tag_text = v; if _lbl: _lbl.text = v

@export var tag_color: Color = UITheme.PRIMARY:
	set(v): tag_color = v; if is_inside_tree(): _rebuild()

@export var removable: bool = true:
	set(v): removable = v; if _close_btn: _close_btn.visible = v

@export var pill_shape: bool = false:
	set(v): pill_shape = v; if is_inside_tree(): _rebuild()

var _lbl:       Label
var _close_btn: Button
var _panel:     PanelContainer

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	_build()

func _build() -> void:
	_panel = PanelContainer.new()
	_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_panel)
	_apply_panel_style()

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 5)
	_panel.add_child(h)

	_lbl = Label.new()
	_lbl.text = tag_text
	_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	_lbl.add_theme_color_override("font_color", tag_color)
	h.add_child(_lbl)

	_close_btn = Button.new()
	_close_btn.text = "✕"
	_close_btn.flat = true
	_close_btn.visible = removable
	_close_btn.focus_mode = Control.FOCUS_NONE
	_close_btn.add_theme_color_override("font_color",       tag_color.darkened(0.1))
	_close_btn.add_theme_color_override("font_hover_color", tag_color.lightened(0.3))
	_close_btn.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	_close_btn.pressed.connect(func(): removed.emit(tag_text); queue_free())
	h.add_child(_close_btn)

func _apply_panel_style() -> void:
	if not _panel: return
	var r   := UITheme.RADIUS_PILL if pill_shape else UITheme.RADIUS_SM
	var bg  := Color(tag_color.r, tag_color.g, tag_color.b, 0.12)
	var s   := StyleBoxFlat.new()
	s.bg_color = bg
	s.corner_radius_top_left     = r; s.corner_radius_top_right    = r
	s.corner_radius_bottom_left  = r; s.corner_radius_bottom_right = r
	s.content_margin_left = 10; s.content_margin_right  = 6
	s.content_margin_top  = 5;  s.content_margin_bottom = 5
	_panel.add_theme_stylebox_override("panel", s)

func _rebuild() -> void:
	for c in get_children(): c.queue_free()
	_lbl = null; _close_btn = null; _panel = null
	_build()
