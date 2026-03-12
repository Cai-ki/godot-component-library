## UIAlert — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIAlert
extends Control

signal dismissed
signal action_pressed

enum AlertType { INFO, SUCCESS, WARNING, DANGER }

@export var alert_type: AlertType = AlertType.INFO:
	set(v): alert_type = v; if is_inside_tree(): _refresh()

@export var title_text: String = "":
	set(v): title_text = v; if _title_lbl: _title_lbl.text = v

@export var body_text: String = "":
	set(v):
		body_text = v
		if _body_lbl: _body_lbl.text = v; _body_lbl.visible = v != ""

@export var dismissable: bool = false:
	set(v): dismissable = v; if _close_btn: _close_btn.visible = v

@export var action_label: String = "":
	set(v):
		action_label = v
		if _action_btn: _action_btn.text = v; _action_btn.visible = v != ""

var _panel: PanelContainer
var _icon_lbl: Label
var _title_lbl: Label
var _body_lbl: Label
var _close_btn: Button
var _action_btn: Button

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build()

func _get_color() -> Color:
	match alert_type:
		AlertType.SUCCESS: return UITheme.SUCCESS
		AlertType.WARNING: return UITheme.WARNING
		AlertType.DANGER:  return UITheme.DANGER
		_: return UITheme.INFO

func _get_icon() -> String:
	match alert_type:
		AlertType.SUCCESS: return "✓"
		AlertType.WARNING: return "⚠"
		AlertType.DANGER:  return "✕"
		_: return "ℹ"

func _build() -> void:
	_panel = PanelContainer.new()
	_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(_panel)

	var outer := HBoxContainer.new()
	outer.add_theme_constant_override("separation", 12)
	_panel.add_child(outer)

	_icon_lbl = Label.new()
	_icon_lbl.add_theme_font_size_override("font_size", UITheme.FONT_LG)
	outer.add_child(_icon_lbl)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 4)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.add_child(col)

	_title_lbl = Label.new()
	_title_lbl.text = title_text
	_title_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	col.add_child(_title_lbl)

	_body_lbl = Label.new()
	_body_lbl.text = body_text
	_body_lbl.visible = body_text != ""
	_body_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	_body_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	_body_lbl.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	col.add_child(_body_lbl)

	_action_btn = Button.new()
	_action_btn.text = action_label
	_action_btn.visible = action_label != ""
	_action_btn.flat = true
	_action_btn.focus_mode = Control.FOCUS_NONE
	_action_btn.pressed.connect(func(): action_pressed.emit())
	col.add_child(_action_btn)

	_close_btn = Button.new()
	_close_btn.text = "✕"
	_close_btn.flat = true
	_close_btn.visible = dismissable
	_close_btn.focus_mode = Control.FOCUS_NONE
	_close_btn.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	_close_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	_close_btn.pressed.connect(func(): dismissed.emit(); queue_free())
	outer.add_child(_close_btn)

	_refresh()

func _refresh() -> void:
	if not _panel: return
	var c := _get_color()
	var s := StyleBoxFlat.new()
	s.bg_color = Color(c.r, c.g, c.b, 0.06)
	s.corner_radius_top_left     = UITheme.RADIUS_MD
	s.corner_radius_top_right    = UITheme.RADIUS_MD
	s.corner_radius_bottom_left  = UITheme.RADIUS_MD
	s.corner_radius_bottom_right = UITheme.RADIUS_MD
	s.border_width_left = 4; s.border_color = c
	s.content_margin_left = 16; s.content_margin_right  = 16
	s.content_margin_top  = 14; s.content_margin_bottom = 14
	_panel.add_theme_stylebox_override("panel", s)
	if _icon_lbl:  _icon_lbl.text = _get_icon()
	if _icon_lbl:  _icon_lbl.add_theme_color_override("font_color", c)
	if _title_lbl: _title_lbl.add_theme_color_override("font_color", c)
	if _action_btn:
		_action_btn.add_theme_color_override("font_color", c)
		_action_btn.add_theme_color_override("font_hover_color", c.lightened(0.2))
