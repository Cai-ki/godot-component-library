## UIInput — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIInput
extends VBoxContainer

signal text_changed(new_text: String)
signal text_submitted(new_text: String)

enum State { DEFAULT, SUCCESS, ERROR, WARNING }

@export var label_text: String = "":
	set(v): label_text = v; if _lbl: _lbl.text = v; if _lbl: _lbl.visible = v != ""

@export var placeholder: String = "":
	set(v): placeholder = v; if _input: _input.placeholder_text = v

@export var hint_text: String = "":
	set(v): hint_text = v; if _hint: _hint.text = v; if _hint: _hint.visible = v != ""

@export var password: bool = false:
	set(v): password = v; if _input: _input.secret = v

@export var disabled: bool = false:
	set(v): disabled = v; if _input: _input.editable = !v; if is_inside_tree(): _refresh_state()

@export var validation_state: State = State.DEFAULT:
	set(v):
		var changed := validation_state != v
		validation_state = v
		if is_inside_tree():
			_refresh_state()
			if changed and validation_state == State.ERROR:
				UI.shake(_input)

var _lbl:   Label
var _input: LineEdit
var _hint:  Label

var text: String:
	get: return _input.text if _input else ""
	set(v): if _input: _input.text = v

func _ready() -> void:
	add_theme_constant_override("separation", 6)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build()

# ── Public API ────────────────────────────────────
func clear() -> void:
	if _input: _input.clear()

func grab_focus_input() -> void:
	if _input: _input.grab_focus()

# ── Internal ──────────────────────────────────────
func _build() -> void:
	_lbl = Label.new()
	_lbl.text = label_text
	_lbl.visible = label_text != ""
	_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	if UITheme.FONT_SANS: _lbl.add_theme_font_override("font", UITheme.FONT_SANS)
	add_child(_lbl)

	_input = LineEdit.new()
	_input.placeholder_text = placeholder
	_input.secret = password
	_input.editable = !disabled
	_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_input.text_changed.connect(func(t): text_changed.emit(t))
	_input.text_submitted.connect(func(t): text_submitted.emit(t))
	add_child(_input)

	_hint = Label.new()
	_hint.text = hint_text
	_hint.visible = hint_text != ""
	_hint.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	if UITheme.FONT_SANS: _hint.add_theme_font_override("font", UITheme.FONT_SANS)
	add_child(_hint)

	_refresh_state()

func _refresh_state() -> void:
	if not _input: return

	var border_c: Color
	var hint_c: Color
	match validation_state:
		State.SUCCESS: border_c = UITheme.SUCCESS;  hint_c = UITheme.SUCCESS
		State.ERROR:   border_c = UITheme.DANGER;   hint_c = UITheme.DANGER
		State.WARNING: border_c = UITheme.WARNING;  hint_c = UITheme.WARNING
		_:             border_c = UITheme.BORDER;   hint_c = UITheme.TEXT_MUTED

	var bw := 2 if validation_state != State.DEFAULT else 1
	var bg := UITheme.SURFACE_3 if disabled else UITheme.SURFACE_2

	var n := _input_style(bg, bw, border_c)
	var f_bc := UITheme.PRIMARY if validation_state == State.DEFAULT else border_c
	var f := _input_style(bg, 2, f_bc)
	var ro := _input_style(UITheme.SURFACE_3, 1, UITheme.BORDER)

	_input.add_theme_stylebox_override("normal",    n)
	_input.add_theme_stylebox_override("focus",     f)
	_input.add_theme_stylebox_override("read_only", ro)
	_input.add_theme_color_override("font_color",              disabled_c())
	_input.add_theme_color_override("font_placeholder_color",  UITheme.TEXT_MUTED)
	_input.add_theme_color_override("caret_color",             UITheme.PRIMARY)
	_input.add_theme_font_size_override("font_size",           UITheme.FONT_MD)
	if UITheme.FONT_SANS: _input.add_theme_font_override("font", UITheme.FONT_SANS)
	if _hint:
		_hint.add_theme_color_override("font_color", hint_c)

func disabled_c() -> Color:
	return UITheme.TEXT_MUTED if disabled else UITheme.TEXT_PRIMARY

func _input_style(bg: Color, bw: int, bc: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.corner_radius_top_left     = UITheme.RADIUS_MD
	s.corner_radius_top_right    = UITheme.RADIUS_MD
	s.corner_radius_bottom_left  = UITheme.RADIUS_MD
	s.corner_radius_bottom_right = UITheme.RADIUS_MD
	s.border_width_top    = bw; s.border_width_bottom = bw
	s.border_width_left   = bw; s.border_width_right  = bw
	s.border_color = bc
	s.content_margin_left   = 12; s.content_margin_right  = 12
	s.content_margin_top    = 10; s.content_margin_bottom = 10
	return s
