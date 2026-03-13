## UIChip — Standalone Component
## Selectable/filterable tag with toggled state, multiple color schemes,
## and optional removable close button.
##
## Usage:
##   var chip := UIChip.new()
##   chip.chip_text = "Vue.js"
##   chip.selectable = true
##   chip.toggled.connect(func(on): print("selected:", on))
##   parent.add_child(chip)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIChip
extends PanelContainer

signal toggled(value: bool)
signal removed(chip_text: String)

enum ColorScheme { PRIMARY, SECONDARY, SUCCESS, WARNING, DANGER, INFO, NEUTRAL }

@export var chip_text: String = "Chip":
	set(v): chip_text = v; if _lbl: _lbl.text = v

@export var color_scheme: ColorScheme = ColorScheme.PRIMARY:
	set(v): color_scheme = v; if is_inside_tree(): _rebuild()

@export var selected: bool = false:
	set(v): selected = v; if is_inside_tree(): _apply_styles()

@export var selectable: bool = false:
	set(v): selectable = v; if is_inside_tree(): _rebuild()

@export var removable: bool = false:
	set(v): removable = v; if _close_btn: _close_btn.visible = v

@export var pill_shape: bool = true:
	set(v): pill_shape = v; if is_inside_tree(): _apply_styles()

var _lbl: Label
var _close_btn: Button


func _ready() -> void:
	size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()


func _build() -> void:
	_apply_styles()

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	add_child(h)

	_lbl = Label.new()
	_lbl.text = chip_text
	_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	_apply_label_color()
	h.add_child(_lbl)

	_close_btn = Button.new()
	_close_btn.text = "✕"
	_close_btn.flat = true
	_close_btn.visible = removable
	_close_btn.focus_mode = Control.FOCUS_NONE
	_close_btn.add_theme_font_size_override("font_size", 10)
	_close_btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	_close_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	_close_btn.pressed.connect(func(): removed.emit(chip_text); queue_free())
	h.add_child(_close_btn)

	if selectable:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		gui_input.connect(_on_gui_input)
		mouse_entered.connect(_on_hover.bind(true))
		mouse_exited.connect(_on_hover.bind(false))


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			selected = not selected
			toggled.emit(selected)


func _on_hover(hovered: bool) -> void:
	if hovered:
		var c := _get_color()
		var s := _make_style(c, true)
		add_theme_stylebox_override("panel", s)
	else:
		_apply_styles()


func _apply_styles() -> void:
	var c := _get_color()
	var s := _make_style(c, false)
	add_theme_stylebox_override("panel", s)
	_apply_label_color()


func _apply_label_color() -> void:
	if _lbl == null: return
	var c := _get_color()
	_lbl.add_theme_color_override("font_color", c if selected else c.lightened(0.1))


func _make_style(c: Color, hovered: bool) -> StyleBoxFlat:
	var r := UITheme.RADIUS_PILL if pill_shape else UITheme.RADIUS_SM
	var s := StyleBoxFlat.new()

	if selected:
		s.bg_color = Color(c.r, c.g, c.b, 0.25 if not hovered else 0.35)
		s.border_color = c
		s.border_width_left = 1; s.border_width_right = 1
		s.border_width_top = 1; s.border_width_bottom = 1
	else:
		s.bg_color = UITheme.SURFACE_3 if hovered else UITheme.SURFACE_2
		s.border_color = UITheme.BORDER_LIGHT if hovered else UITheme.BORDER
		s.border_width_left = 1; s.border_width_right = 1
		s.border_width_top = 1; s.border_width_bottom = 1

	s.corner_radius_top_left = r; s.corner_radius_top_right = r
	s.corner_radius_bottom_left = r; s.corner_radius_bottom_right = r
	s.content_margin_left = 12; s.content_margin_right = 8 if removable else 12
	s.content_margin_top = 5; s.content_margin_bottom = 5
	return s


func _get_color() -> Color:
	match color_scheme:
		ColorScheme.PRIMARY: return UITheme.PRIMARY
		ColorScheme.SECONDARY: return UITheme.SECONDARY
		ColorScheme.SUCCESS: return UITheme.SUCCESS
		ColorScheme.WARNING: return UITheme.WARNING
		ColorScheme.DANGER: return UITheme.DANGER
		ColorScheme.INFO: return UITheme.INFO
		_: return UITheme.TEXT_SECONDARY


func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()
	_lbl = null
	_close_btn = null
	_build()
