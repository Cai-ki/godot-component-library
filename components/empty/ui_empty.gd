## UIEmpty — Standalone Component
## Empty state placeholder with icon, title, description, and optional action.
##
## Usage:
##   var empty := UIEmpty.new()
##   empty.icon_text = "📭"
##   empty.title_text = "No messages"
##   empty.description_text = "Your inbox is empty."
##   empty.action_label = "Compose"
##   empty.action_pressed.connect(func(): print("compose"))
##   parent.add_child(empty)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIEmpty
extends VBoxContainer

signal action_pressed

@export var icon_text: String = "◇":
	set(v): icon_text = v; if _icon_lbl: _icon_lbl.text = v

@export var title_text: String = "No data":
	set(v): title_text = v; if _title_lbl: _title_lbl.text = v

@export var description_text: String = "":
	set(v):
		description_text = v
		if _desc_lbl: _desc_lbl.text = v; _desc_lbl.visible = v != ""

@export var action_label: String = "":
	set(v):
		action_label = v
		if _action_btn: _action_btn.text = v; _action_btn.visible = v != ""

@export var accent_color: Color = Color("6C63FF"):   # UITheme.PRIMARY
	set(v): accent_color = v; if is_inside_tree(): _apply_styles()

var _icon_lbl:   Label
var _title_lbl:  Label
var _desc_lbl:   Label
var _action_btn: Button


func _ready() -> void:
	add_theme_constant_override("separation", 12)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	alignment = BoxContainer.ALIGNMENT_CENTER
	_build()


func _build() -> void:
	# Icon
	_icon_lbl = Label.new()
	_icon_lbl.text = icon_text
	_icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_icon_lbl.add_theme_font_size_override("font_size", 40)
	_icon_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	add_child(_icon_lbl)

	# Title
	_title_lbl = Label.new()
	_title_lbl.text = title_text
	_title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_lbl.add_theme_font_size_override("font_size", UITheme.FONT_LG)
	_title_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	add_child(_title_lbl)

	# Description
	_desc_lbl = Label.new()
	_desc_lbl.text = description_text
	_desc_lbl.visible = description_text != ""
	_desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_desc_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	_desc_lbl.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	add_child(_desc_lbl)

	# Action button
	_action_btn = Button.new()
	_action_btn.text = action_label
	_action_btn.visible = action_label != ""
	_action_btn.focus_mode = Control.FOCUS_NONE
	_action_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_action_btn.pressed.connect(func(): action_pressed.emit())
	add_child(_action_btn)

	_apply_styles()


func _apply_styles() -> void:
	if not _action_btn: return

	var n := _btn_style(accent_color)
	var h := _btn_style(accent_color.lightened(0.12))
	var p := _btn_style(accent_color.darkened(0.1))

	_action_btn.add_theme_stylebox_override("normal",  n)
	_action_btn.add_theme_stylebox_override("hover",   h)
	_action_btn.add_theme_stylebox_override("pressed", p)
	_action_btn.add_theme_stylebox_override("focus",   n)
	_action_btn.add_theme_color_override("font_color",       Color.WHITE)
	_action_btn.add_theme_color_override("font_hover_color", Color.WHITE)
	_action_btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)


func _btn_style(bg: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.corner_radius_top_left     = UITheme.RADIUS_MD
	s.corner_radius_top_right    = UITheme.RADIUS_MD
	s.corner_radius_bottom_left  = UITheme.RADIUS_MD
	s.corner_radius_bottom_right = UITheme.RADIUS_MD
	s.content_margin_left   = 20; s.content_margin_right  = 20
	s.content_margin_top    = 10; s.content_margin_bottom = 10
	return s
