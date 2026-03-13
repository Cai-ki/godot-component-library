## UICheckbox — Standalone Component
## Custom-styled checkbox with optional label.
##
## Usage:
##   var cb := UICheckbox.new()
##   cb.label_text = "Accept Terms"
##   cb.toggled.connect(func(v): print(v))
##   parent.add_child(cb)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UICheckbox
extends HBoxContainer

signal toggled(value: bool)

@export var checked: bool = false:
	set(v): checked = v; if is_inside_tree(): _refresh()

@export var label_text: String = "":
	set(v):
		label_text = v
		if _text_lbl: _text_lbl.text = v; _text_lbl.visible = v != ""

@export var disabled: bool = false:
	set(v): disabled = v; if is_inside_tree(): _refresh()

@export var accent_color: Color = Color("6C63FF"):   # UITheme.PRIMARY
	set(v): accent_color = v; if is_inside_tree(): _refresh()

const BOX_SIZE := 20.0

var _box:      Control
var _text_lbl: Label
var _hover:    bool = false


func _ready() -> void:
	add_theme_constant_override("separation", 10)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()


# ── Build ─────────────────────────────────────────────────────────────────────

func _build() -> void:
	# Checkbox box (custom drawn)
	_box = Control.new()
	_box.custom_minimum_size = Vector2(BOX_SIZE, BOX_SIZE)
	_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_box.draw.connect(_draw_box)
	add_child(_box)

	# Label
	_text_lbl = Label.new()
	_text_lbl.text = label_text
	_text_lbl.visible = label_text != ""
	_text_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	_text_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	_text_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_text_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	add_child(_text_lbl)

	gui_input.connect(_on_input)
	mouse_entered.connect(func(): _hover = true;  _box.queue_redraw())
	mouse_exited.connect(func():  _hover = false; _box.queue_redraw())


func _on_input(event: InputEvent) -> void:
	if disabled: return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			checked = !checked
			toggled.emit(checked)


func _refresh() -> void:
	if _box: _box.queue_redraw()
	if _text_lbl:
		_text_lbl.add_theme_color_override("font_color",
			UITheme.TEXT_MUTED if disabled else UITheme.TEXT_PRIMARY)


# ── Draw ──────────────────────────────────────────────────────────────────────

func _draw_box() -> void:
	var sz := _box.size
	var rect := Rect2(Vector2.ZERO, sz)

	var s := StyleBoxFlat.new()
	var rad := UITheme.RADIUS_XS
	s.corner_radius_top_left     = rad
	s.corner_radius_top_right    = rad
	s.corner_radius_bottom_left  = rad
	s.corner_radius_bottom_right = rad

	if checked:
		var c := accent_color
		if _hover and not disabled: c = c.lightened(0.15)
		if disabled: c = UITheme.SURFACE_4
		s.bg_color = c
	else:
		s.bg_color = UITheme.SURFACE_4 if _hover else UITheme.SURFACE_3
		if disabled: s.bg_color = UITheme.SURFACE_3
		s.border_width_top    = 1; s.border_width_bottom = 1
		s.border_width_left   = 1; s.border_width_right  = 1
		s.border_color = UITheme.BORDER_LIGHT if _hover else UITheme.BORDER

	_box.draw_style_box(s, rect)

	# Checkmark
	if checked:
		var font := ThemeDB.fallback_font
		var fs := 14
		var text := "✓"
		var tsz := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		var pos := sz / 2.0 + Vector2(-tsz.x * 0.5, tsz.y * 0.3)
		var tc := Color.WHITE if not disabled else UITheme.TEXT_MUTED
		_box.draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, tc)
